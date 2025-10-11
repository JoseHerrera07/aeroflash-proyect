from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import create_engine, Column, Integer, String, Float, DateTime, Boolean, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, Session, relationship
from pydantic import BaseModel, EmailStr
from typing import List, Optional
from datetime import datetime
import os

# Configuración de base de datos
DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "postgresql://flightadmin:password@localhost:5432/flightbookingdb"
)

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

# ==================== MODELOS DE BASE DE DATOS ====================

class Flight(Base):
    __tablename__ = "flights"
    
    id = Column(Integer, primary_key=True, index=True)
    flight_number = Column(String, unique=True, index=True)
    origin = Column(String)
    destination = Column(String)
    departure_time = Column(DateTime)
    arrival_time = Column(DateTime)
    price = Column(Float)
    available_seats = Column(Integer)
    total_seats = Column(Integer)
    airline = Column(String)
    
    bookings = relationship("Booking", back_populates="flight")

class Customer(Base):
    __tablename__ = "customers"
    
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String)
    email = Column(String, unique=True, index=True)
    phone = Column(String)
    created_at = Column(DateTime, default=datetime.utcnow)
    
    bookings = relationship("Booking", back_populates="customer")

class Booking(Base):
    __tablename__ = "bookings"
    
    id = Column(Integer, primary_key=True, index=True)
    customer_id = Column(Integer, ForeignKey("customers.id"))
    flight_id = Column(Integer, ForeignKey("flights.id"))
    booking_date = Column(DateTime, default=datetime.utcnow)
    passengers = Column(Integer)
    total_price = Column(Float)
    status = Column(String, default="confirmed")
    
    customer = relationship("Customer", back_populates="bookings")
    flight = relationship("Flight", back_populates="bookings")

# Crear tablas
Base.metadata.create_all(bind=engine)

# ==================== SCHEMAS PYDANTIC ====================

class FlightBase(BaseModel):
    flight_number: str
    origin: str
    destination: str
    departure_time: datetime
    arrival_time: datetime
    price: float
    available_seats: int
    total_seats: int
    airline: str

class FlightCreate(FlightBase):
    pass

class FlightResponse(FlightBase):
    id: int
    
    class Config:
        from_attributes = True

class CustomerBase(BaseModel):
    name: str
    email: EmailStr
    phone: str

class CustomerCreate(CustomerBase):
    pass

class CustomerResponse(CustomerBase):
    id: int
    created_at: datetime
    
    class Config:
        from_attributes = True

class BookingBase(BaseModel):
    customer_id: int
    flight_id: int
    passengers: int

class BookingCreate(BookingBase):
    pass

class BookingResponse(BookingBase):
    id: int
    booking_date: datetime
    total_price: float
    status: str
    
    class Config:
        from_attributes = True

class BookingDetailResponse(BaseModel):
    id: int
    booking_date: datetime
    passengers: int
    total_price: float
    status: str
    customer: CustomerResponse
    flight: FlightResponse
    
    class Config:
        from_attributes = True

# ==================== DEPENDENCY ====================

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# ==================== FASTAPI APP ====================

app = FastAPI(
    title="Flight Booking API",
    description="API para gestión y reserva de vuelos",
    version="1.0.0"
)

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ==================== ENDPOINTS ====================

@app.get("/")
def read_root():
    return {
        "message": "Flight Booking API",
        "version": "1.0.0",
        "status": "active"
    }

@app.get("/health")
def health_check():
    return {"status": "healthy"}

# ========== FLIGHTS ==========

@app.post("/flights/", response_model=FlightResponse)
def create_flight(flight: FlightCreate, db: Session = Depends(get_db)):
    db_flight = Flight(**flight.dict())
    db.add(db_flight)
    db.commit()
    db.refresh(db_flight)
    return db_flight

@app.get("/flights/", response_model=List[FlightResponse])
def get_flights(
    skip: int = 0,
    limit: int = 100,
    origin: Optional[str] = None,
    destination: Optional[str] = None,
    db: Session = Depends(get_db)
):
    query = db.query(Flight)
    
    if origin:
        query = query.filter(Flight.origin.ilike(f"%{origin}%"))
    if destination:
        query = query.filter(Flight.destination.ilike(f"%{destination}%"))
    
    flights = query.offset(skip).limit(limit).all()
    return flights

@app.get("/flights/{flight_id}", response_model=FlightResponse)
def get_flight(flight_id: int, db: Session = Depends(get_db)):
    flight = db.query(Flight).filter(Flight.id == flight_id).first()
    if not flight:
        raise HTTPException(status_code=404, detail="Flight not found")
    return flight

@app.put("/flights/{flight_id}", response_model=FlightResponse)
def update_flight(flight_id: int, flight: FlightCreate, db: Session = Depends(get_db)):
    db_flight = db.query(Flight).filter(Flight.id == flight_id).first()
    if not db_flight:
        raise HTTPException(status_code=404, detail="Flight not found")
    
    for key, value in flight.dict().items():
        setattr(db_flight, key, value)
    
    db.commit()
    db.refresh(db_flight)
    return db_flight

@app.delete("/flights/{flight_id}")
def delete_flight(flight_id: int, db: Session = Depends(get_db)):
    flight = db.query(Flight).filter(Flight.id == flight_id).first()
    if not flight:
        raise HTTPException(status_code=404, detail="Flight not found")
    
    db.delete(flight)
    db.commit()
    return {"message": "Flight deleted successfully"}

# ========== CUSTOMERS ==========

@app.post("/customers/", response_model=CustomerResponse)
def create_customer(customer: CustomerCreate, db: Session = Depends(get_db)):
    # Verificar si el email ya existe
    existing = db.query(Customer).filter(Customer.email == customer.email).first()
    if existing:
        raise HTTPException(status_code=400, detail="Email already registered")
    
    db_customer = Customer(**customer.dict())
    db.add(db_customer)
    db.commit()
    db.refresh(db_customer)
    return db_customer

@app.get("/customers/", response_model=List[CustomerResponse])
def get_customers(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    customers = db.query(Customer).offset(skip).limit(limit).all()
    return customers

@app.get("/customers/{customer_id}", response_model=CustomerResponse)
def get_customer(customer_id: int, db: Session = Depends(get_db)):
    customer = db.query(Customer).filter(Customer.id == customer_id).first()
    if not customer:
        raise HTTPException(status_code=404, detail="Customer not found")
    return customer

# ========== BOOKINGS ==========

@app.post("/bookings/", response_model=BookingResponse)
def create_booking(booking: BookingCreate, db: Session = Depends(get_db)):
    # Verificar que el vuelo existe
    flight = db.query(Flight).filter(Flight.id == booking.flight_id).first()
    if not flight:
        raise HTTPException(status_code=404, detail="Flight not found")
    
    # Verificar disponibilidad
    if flight.available_seats < booking.passengers:
        raise HTTPException(status_code=400, detail="Not enough available seats")
    
    # Verificar que el cliente existe
    customer = db.query(Customer).filter(Customer.id == booking.customer_id).first()
    if not customer:
        raise HTTPException(status_code=404, detail="Customer not found")
    
    # Calcular precio total
    total_price = flight.price * booking.passengers
    
    # Crear reserva
    db_booking = Booking(
        customer_id=booking.customer_id,
        flight_id=booking.flight_id,
        passengers=booking.passengers,
        total_price=total_price
    )
    
    # Actualizar asientos disponibles
    flight.available_seats -= booking.passengers
    
    db.add(db_booking)
    db.commit()
    db.refresh(db_booking)
    
    return db_booking

@app.get("/bookings/", response_model=List[BookingDetailResponse])
def get_bookings(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    bookings = db.query(Booking).offset(skip).limit(limit).all()
    return bookings

@app.get("/bookings/{booking_id}", response_model=BookingDetailResponse)
def get_booking(booking_id: int, db: Session = Depends(get_db)):
    booking = db.query(Booking).filter(Booking.id == booking_id).first()
    if not booking:
        raise HTTPException(status_code=404, detail="Booking not found")
    return booking

@app.get("/customers/{customer_id}/bookings", response_model=List[BookingDetailResponse])
def get_customer_bookings(customer_id: int, db: Session = Depends(get_db)):
    bookings = db.query(Booking).filter(Booking.customer_id == customer_id).all()
    return bookings

@app.delete("/bookings/{booking_id}")
def cancel_booking(booking_id: int, db: Session = Depends(get_db)):
    booking = db.query(Booking).filter(Booking.id == booking_id).first()
    if not booking:
        raise HTTPException(status_code=404, detail="Booking not found")
    
    # Devolver asientos al vuelo
    flight = db.query(Flight).filter(Flight.id == booking.flight_id).first()
    if flight:
        flight.available_seats += booking.passengers
    
    # Cambiar estado
    booking.status = "cancelled"
    
    db.commit()
    return {"message": "Booking cancelled successfully"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=5000)
