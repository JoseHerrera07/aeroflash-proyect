import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';
import { Flight, Customer, Booking, BookingDetail } from '../models/flight.model';

@Injectable({
  providedIn: 'root'
})
export class ApiService {
  private apiUrl = environment.apiUrl;

  constructor(private http: HttpClient) {}

  // ========== FLIGHTS ==========
  getFlights(origin?: string, destination?: string): Observable<Flight[]> {
    let url = `${this.apiUrl}/flights/`;
    const params: string[] = [];
    
    if (origin) params.push(`origin=${origin}`);
    if (destination) params.push(`destination=${destination}`);
    
    if (params.length > 0) {
      url += '?' + params.join('&');
    }
    
    return this.http.get<Flight[]>(url);
  }

  getFlight(id: number): Observable<Flight> {
    return this.http.get<Flight>(`${this.apiUrl}/flights/${id}`);
  }

  createFlight(flight: Flight): Observable<Flight> {
    return this.http.post<Flight>(`${this.apiUrl}/flights/`, flight);
  }

  updateFlight(id: number, flight: Flight): Observable<Flight> {
    return this.http.put<Flight>(`${this.apiUrl}/flights/${id}`, flight);
  }

  deleteFlight(id: number): Observable<any> {
    return this.http.delete(`${this.apiUrl}/flights/${id}`);
  }

  // ========== CUSTOMERS ==========
  getCustomers(): Observable<Customer[]> {
    return this.http.get<Customer[]>(`${this.apiUrl}/customers/`);
  }

  getCustomer(id: number): Observable<Customer> {
    return this.http.get<Customer>(`${this.apiUrl}/customers/${id}`);
  }

  createCustomer(customer: Customer): Observable<Customer> {
    return this.http.post<Customer>(`${this.apiUrl}/customers/`, customer);
  }

  // ========== BOOKINGS ==========
  getBookings(): Observable<BookingDetail[]> {
    return this.http.get<BookingDetail[]>(`${this.apiUrl}/bookings/`);
  }

  getBooking(id: number): Observable<BookingDetail> {
    return this.http.get<BookingDetail>(`${this.apiUrl}/bookings/${id}`);
  }

  createBooking(booking: Booking): Observable<Booking> {
    return this.http.post<Booking>(`${this.apiUrl}/bookings/`, booking);
  }

  cancelBooking(id: number): Observable<any> {
    return this.http.delete(`${this.apiUrl}/bookings/${id}`);
  }

  getCustomerBookings(customerId: number): Observable<BookingDetail[]> {
    return this.http.get<BookingDetail[]>(`${this.apiUrl}/customers/${customerId}/bookings`);
  }
}