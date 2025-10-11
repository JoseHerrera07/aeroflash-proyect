export interface Flight {
  id?: number;
  flight_number: string;
  origin: string;
  destination: string;
  departure_time: string;
  arrival_time: string;
  price: number;
  available_seats: number;
  total_seats: number;
  airline: string;
}

export interface Customer {
  id?: number;
  name: string;
  email: string;
  phone: string;
  created_at?: string;
}

export interface Booking {
  id?: number;
  customer_id: number;
  flight_id: number;
  passengers: number;
  booking_date?: string;
  total_price?: number;
  status?: string;
}

export interface BookingDetail extends Booking {
  customer: Customer;
  flight: Flight;
}