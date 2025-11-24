import logging
import os
import random
import time
from fastapi import FastAPI, Response
from prometheus_fastapi_instrumentator import Instrumentator

# 1. Crear carpeta de logs si no existe
os.makedirs("/app/logs", exist_ok=True)

# 2. Configurar logging para escribir en ARCHIVO y en CONSOLA
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler("/app/logs/api.log"),  # <--- AQUÍ GUARDA EL LOG
        logging.StreamHandler()                    # Aquí imprime en pantalla
    ]
)
logger = logging.getLogger("backend-api")

app = FastAPI()
Instrumentator().instrument(app).expose(app)

@app.get("/")
def read_root():
    logger.info("LOG_TEST: Cliente entro al home")
    return {"mensaje": "Sistema funcionando"}

@app.get("/api/test")
def test_route():
    logger.info("LOG_TEST: Alguien ejecuto el test")
    if random.random() < 0.3:
        logger.error("LOG_TEST: Error simulado 500")
        return Response(status_code=500)
    return {"status": "ok"}
