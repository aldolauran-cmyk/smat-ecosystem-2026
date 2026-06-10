import paho.mqtt.client as mqtt
import json
import time
import random

# CONFIGURACIÓN DEL BROKER
BROKER = "broker.hivemq.com"  # Broker público para pruebas académicas
PORT = 1883
TOPIC = "fisi/smat/estaciones/1" # Publica específicamente en la estación 1

client = mqtt.Client()
client.connect(BROKER, PORT)

print(f"📡 Sensor MQTT iniciado. Publicando en el tópico: {TOPIC}")

while True:
    payload = {
        "valor": round(random.uniform(20.0, 60.0), 2),
        "timestamp": time.time()
    }
    
    # Publicar datos serializados en JSON
    client.publish(TOPIC, json.dumps(payload))
    print(f"📤 Enviado por MQTT: {payload}")
    
    # El sensor transmite de forma ligera cada 10 segundos
    time.sleep(10)