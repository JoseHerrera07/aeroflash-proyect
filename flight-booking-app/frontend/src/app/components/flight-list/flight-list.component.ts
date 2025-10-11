import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { ApiService } from '../../services/api.service';
import { Flight } from '../../models/flight.model';

@Component({
  selector: 'app-flight-list',
  templateUrl: './flight-list.component.html',
  styleUrls: ['./flight-list.component.css']
})
export class FlightListComponent implements OnInit {
  flights: Flight[] = [];
  loading: boolean = true;
  error: string = '';
  searchOrigin: string = '';
  searchDestination: string = '';

  constructor(
    private apiService: ApiService,
    private route: ActivatedRoute,
    private router: Router
  ) {}

  ngOnInit(): void {
    this.route.queryParams.subscribe(params => {
      this.searchOrigin = params['origin'] || '';
      this.searchDestination = params['destination'] || '';
      this.loadFlights();
    });
  }

  loadFlights(): void {
    this.loading = true;
    this.error = '';
    
    this.apiService.getFlights(this.searchOrigin, this.searchDestination)
      .subscribe({
        next: (data) => {
          this.flights = data;
          this.loading = false;
        },
        error: (err) => {
          this.error = 'Error loading flights. Please try again.';
          this.loading = false;
          console.error(err);
        }
      });
  }

  searchFlights(): void {
    this.router.navigate(['/flights'], {
      queryParams: {
        origin: this.searchOrigin,
        destination: this.searchDestination
      }
    });
  }

  bookFlight(flightId: number): void {
    this.router.navigate(['/book', flightId]);
  }

  formatDate(dateString: string): string {
    const date = new Date(dateString);
    return date.toLocaleString('en-US', {
      month: 'short',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  }

  calculateDuration(departure: string, arrival: string): string {
    const dep = new Date(departure);
    const arr = new Date(arrival);
    const diff = arr.getTime() - dep.getTime();
    const hours = Math.floor(diff / (1000 * 60 * 60));
    const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
    return `${hours}h ${minutes}m`;
  }
}