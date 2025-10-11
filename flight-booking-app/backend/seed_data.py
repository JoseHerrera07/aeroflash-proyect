import requests
from datetime import datetime, timedelta

BASE_URL = "http://localhost:5000"

# Crear vuelos de prueba
flights = [
    {
        "flight_number": "AA101",
        "origin": "New York",
        "destination": "Los Angeles",
        "departure_time": (datetime.now() + timedelta(days=1)).isoformat(),
        "arrival_time": (datetime.now() + timedelta(days=1, hours=6)).isoformat(),
        "price": 250.00,
        "available_seats": 150,
        "total_seats": 180,
        "airline": "American Airlines"
    },
    {
        "flight_number": "UA202",
        "origin": "Miami",
        "destination": "Chicago",
        "departure_time": (datetime.now() + timedelta(days=2)).isoformat(),
        "arrival_time": (datetime.now() + timedelta(days=2, hours=3)).isoformat(),
        "price": 180.00,
        "available_seats": 100,
        "total_seats": 120,
        "airline": "United Airlines"
    },
    {
        "flight_number": "DL303",
        "origin": "Seattle",
        "destination": "Boston",
        "departure_time": (datetime.now() + timedelta(days=3)).isoformat(),
        "arrival_time": (datetime.now() + timedelta(days=3, hours=5)).isoformat(),
        "price": 320.00,
        "available_seats": 80,
        "total_seats": 100,
        "airline": "Delta Airlines"
    }
]

print("🛫 Creando vuelos de prueba...")
for flight in flights:
    response = requests.post(f"{BASE_URL}/flights/", json=flight)
    print(f"✅ Vuelo {flight['flight_number']} creado")

# Crear clientes de prueba
customers = [
    {"name": "John Doe", "email": "john@example.com", "phone": "+1234567890"},
    {"name": "Jane Smith", "email": "jane@example.com", "phone": "+1987654321"},
]

print("\n👥 Creando clientes de prueba...")
for customer in customers:
    response = requests.post(f"{BASE_URL}/customers/", json=customer)
    print(f"✅ Cliente {customer['name']} creado")

print("\n✅ ¡Datos de prueba creados exitosamente!")
