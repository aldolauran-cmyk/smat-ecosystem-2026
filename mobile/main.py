from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(title="Ecosistema Digital UNMSM")

# Esto le dice al backend: "Acepta peticiones de cualquier lugar (como Chrome)"
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], 
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def read_root():
    return {"message": "Backend SMAT Online"}

@app.get("/estaciones/")
def get_estaciones():
    return [
        {"id": 1, "nombre": "Estación Central - FISI", "ubicacion": "Ciudad Universitaria"},
        {"id": 2, "nombre": "Nodo Satelital 01", "ubicacion": "Facultad de Sistemas"}
    ]