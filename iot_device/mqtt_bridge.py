import paho.mqtt.client as mqtt
import requests
import json
import sys
import time

# CONFIGURACIÓN DEL ENTORNO SMAT
MQTT_BROKER = "broker.hivemq.com"
MQTT_PORT = 1883
MQTT_TOPIC = "fisi/smat/estaciones/+/lecturas" # El '+' es un wildcard para el ID de la estación

API_URL = "http://localhost:8000/lecturas/"
JWT_TOKEN = "TU_TOKEN_JWT_AQUI" # Reemplaza con tu token JWT de administrador actual

# --- RETO SEMANA 11: CACHÉ LOCAL PARA FILTRO DE RUIDO ---
# Estructura: { estacion_id: {"valor": float, "last_post_time": float} }
cache_estaciones = {}

def on_connect(client, userdata, flags, rc):
    if rc == 0:
        print("🟢 Conectado exitosamente al Broker MQTT")
        client.subscribe(MQTT_TOPIC)
        print(f"📡 Escuchando transmisiones en el tópico: {MQTT_TOPIC}")
    else:
        print(f"🔴 Error de conexión al Broker. Código de retorno: {rc}")
        sys.exit(1)

def on_message(client, userdata, msg):
    try:
        # 1. Decodificar el payload binario de MQTT a JSON
        payload_raw = msg.payload.decode("utf-8")
        data_json = json.loads(payload_raw)
        
        # 2. Extraer el ID dinámico de la estación desde el tópico
        # "fisi/smat/estaciones/1/lecturas" -> split('/') -> ['fisi', 'smat', 'estaciones', '1', 'lecturas']
        topic_parts = msg.topic.split('/')
        estacion_id = int(topic_parts[3])
        
        nuevo_valor = float(data_json["valor"])
        tiempo_actual = time.time()
        
        print(f"\n📩 Telemetría recibida MQTT -> Estación [{estacion_id}]: {nuevo_valor} cm")

        # --- APLICACIÓN DEL FILTRO DE UMBRAL (DEADBAND FILTER) ---
        debe_enviar = False
        razon_envio = ""

        if estacion_id not in cache_estaciones:
            # Si es la primera vez que vemos la estación, se envía sí o sí
            debe_enviar = True
            razon_envio = "Primer registro de la estación"
        else:
            datos_viejos = cache_estaciones[estacion_id]
            valor_anterior = datos_viejos["valor"]
            ultimo_envio = datos_viejos["last_post_time"]

            # Calcular la variación del 5%
            variacion_absoluta = abs(nuevo_valor - valor_anterior)
            umbral_limite = valor_anterior * 0.05
            tiempo_transcurrido = tiempo_actual - ultimo_envio

            if variacion_absoluta > umbral_limite:
                debe_enviar = True
                razon_envio = f"Variación mayor al 5% (Cambió de {valor_anterior} a {nuevo_valor})"
            elif tiempo_transcurrido > 60.0:
                debe_enviar = True
                razon_envio = f"Keep-alive: Pasaron {round(tiempo_transcurrido, 1)}s desde el último envío"

        # --- PROCESO DE INGESTA HTTP POST ---
        if debe_enviar:
            print(f"🎯 [FILTRO PASADO] Razón: {razon_envio}. Enviando a API...")
            
            api_payload = {
                "valor": nuevo_valor,
                "estacion_id": estacion_id
            }
            headers = {
                "Content-Type": "application/json",
                "Authorization": f"Bearer {JWT_TOKEN}"
            }
            
            response = requests.post(API_URL, json=api_payload, headers=headers)

            if response.status_code in [200, 201]:
                print(f"💾 [DB Sincronizada] Lectura de {nuevo_valor} cm guardada.")
                # Actualizamos la caché únicamente si la base de datos la aceptó con éxito
                cache_estaciones[estacion_id] = {
                    "valor": nuevo_valor,
                    "last_post_time": tiempo_actual
                }
            else:
                print(f"⚠️ [Fallo de Ingesta] API rechazó el dato. Código: {response.status_code}")
        else:
            print("🛑 [FILTRO BLOQUEADO] El dato es redundante. Ignorando para optimizar almacenamiento.")

    except KeyError as e:
        print(f"❌ Error de esquema: Falta la llave {e} en el payload MQTT.")
    except ValueError:
        print("❌ Error de casteo: Datos corruptos o no numéricos.")
    except Exception as e:
        print(f"❌ Error crítico en el Bridge: {e}")

# Inicialización del cliente MQTT Bridge
bridge_client = mqtt.Client()
bridge_client.on_connect = on_connect
bridge_client.on_message = on_message

try:
    print("🚀 Inicializando el Bridge de Acoplamiento SMAT (Semana 11)...")
    bridge_client.connect(MQTT_BROKER, MQTT_PORT, 60)
    bridge_client.loop_forever()
except KeyboardInterrupt:
    print("\n🛑 Bridge detenido por el administrador.")