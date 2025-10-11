import { Component } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent {
  searchOrigin: string = '';
  searchDestination: string = '';

  constructor(private router: Router) {}

  searchFlights() {
    this.router.navigate(['/flights'], {
      queryParams: {
        origin: this.searchOrigin,
        destination: this.searchDestination
      }
    });
  }
}
