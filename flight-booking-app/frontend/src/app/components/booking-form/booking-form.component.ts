import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { ApiService } from '../../services/api.service';
import { Flight, Customer, Booking } from '../../models/flight.model';

@Component({
  selector: 'app-booking-form',
  templateUrl: './booking-form.component.html',
  styleUrls: ['./booking-form.component.css']
})
export class BookingFormComponent implements OnInit {
  bookingForm: FormGroup;
  flight: Flight | null = null;
  loading: boolean = true;
  submitting: boolean = false;
  error: string = '';
  success: boolean = false;

  constructor(
    private fb: FormBuilder,
    private apiService: ApiService,
    private route: ActivatedRoute,
    private router: Router
  ) {
    this.bookingForm = this.fb.group({
      name: ['', [Validators.required, Validators.minLength(3)]],
      email: ['', [Validators.required, Validators.email]],
      phone: ['', [Validators.required, Validators.pattern(/^\+?[0-9]{10,15}$/)]],
      passengers: [1, [Validators.required, Validators.min(1), Validators.max(10)]]
    });
  }

  ngOnInit(): void {
    const flightId = Number(this.route.snapshot.paramMap.get('id'));
    this.loadFlight(flightId);
  }

  loadFlight(id: number): void {
    this.apiService.getFlight(id).subscribe({
      next: (data) => {
        this.flight = data;
        this.loading = false;
      },
      error: (err) => {
        this.error = 'Flight not found';
        this.loading = false;
        console.error(err);
      }
    });
  }

  get totalPrice(): number {
    if (!this.flight) return 0;
    return this.flight.price * this.bookingForm.get('passengers')?.value || 0;
  }

  onSubmit(): void {
    if (this.bookingForm.invalid || !this.flight) return;

    this.submitting = true;
    this.error = '';

    const customerData: Customer = {
      name: this.bookingForm.value.name,
      email: this.bookingForm.value.email,
      phone: this.bookingForm.value.phone
    };

    // Primero crear o obtener el cliente
    this.apiService.createCustomer(customerData).subscribe({
      next: (customer) => {
        this.createBooking(customer.id!, this.flight!.id!);
      },
      error: (err) => {
        // Si el email ya existe, intentar obtener el cliente
        if (err.status === 400) {
          this.apiService.getCustomers().subscribe({
            next: (customers) => {
              const existingCustomer = customers.find(c => c.email === customerData.email);
              if (existingCustomer) {
                this.createBooking(existingCustomer.id!, this.flight!.id!);
              } else {
                this.error = 'Error creating customer';
                this.submitting = false;
              }
            },
            error: () => {
              this.error = 'Error processing booking';
              this.submitting = false;
            }
          });
        } else {
          this.error = 'Error creating customer';
          this.submitting = false;
        }
      }
    });
  }

  createBooking(customerId: number, flightId: number): void {
    const bookingData: Booking = {
      customer_id: customerId,
      flight_id: flightId,
      passengers: this.bookingForm.value.passengers
    };

    this.apiService.createBooking(bookingData).subscribe({
      next: () => {
        this.success = true;
        this.submitting = false;
        setTimeout(() => {
          this.router.navigate(['/bookings']);
        }, 2000);
      },
      error: (err) => {
        this.error = err.error?.detail || 'Error creating booking';
        this.submitting = false;
      }
    });
  }

  formatDate(dateString: string): string {
    const date = new Date(dateString);
    return date.toLocaleString('en-US', {
      weekday: 'short',
      month: 'short',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  }
}