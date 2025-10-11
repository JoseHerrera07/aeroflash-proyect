import { Component, OnInit } from '@angular/core';
import { ApiService } from '../../services/api.service';
import { BookingDetail } from '../../models/flight.model';

@Component({
  selector: 'app-booking-list',
  templateUrl: './booking-list.component.html',
  styleUrls: ['./booking-list.component.css']
})
export class BookingListComponent implements OnInit {
  bookings: BookingDetail[] = [];
  loading: boolean = true;
  error: string = '';
  searchEmail: string = '';
  filteredBookings: BookingDetail[] = [];

  constructor(private apiService: ApiService) {}

  ngOnInit(): void {
    this.loadBookings();
  }

  loadBookings(): void {
    this.loading = true;
    this.error = '';
    
    this.apiService.getBookings().subscribe({
      next: (data) => {
        this.bookings = data;
        this.filteredBookings = data;
        this.loading = false;
      },
      error: (err) => {
        this.error = 'Error loading bookings. Please try again.';
        this.loading = false;
        console.error(err);
      }
    });
  }

  filterBookings(): void {
    if (!this.searchEmail.trim()) {
      this.filteredBookings = this.bookings;
      return;
    }

    this.filteredBookings = this.bookings.filter(booking =>
      booking.customer.email.toLowerCase().includes(this.searchEmail.toLowerCase())
    );
  }

  cancelBooking(bookingId: number): void {
    if (!confirm('Are you sure you want to cancel this booking?')) {
      return;
    }

    this.apiService.cancelBooking(bookingId).subscribe({
      next: () => {
        alert('Booking cancelled successfully');
        this.loadBookings();
      },
      error: (err) => {
        alert('Error cancelling booking');
        console.error(err);
      }
    });
  }

  formatDate(dateString: string): string {
    const date = new Date(dateString);
    return date.toLocaleString('en-US', {
      month: 'short',
      day: 'numeric',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  }

  getStatusClass(status: string): string {
    return status === 'confirmed' ? 'status-confirmed' : 'status-cancelled';
  }
}