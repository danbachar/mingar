import { LocationDTO } from '../DTO/location.dto';
import { Injectable } from '@nestjs/common';
import { sqrt, cos } from 'mathjs';

@Injectable()
export class LocationService {
    public calculateDistanceInMeters(location1: LocationDTO, location2: LocationDTO): number {

        const diff = Math.abs(location1.lat - location2.lat);

        const lat =   diff / 2 * 0.01745;
        const dx = 111.3 * cos(lat) * (diff);
        const dy = 111.3 * diff;

        const distanceInKm =  sqrt(dx * dx + dy * dy);

        return distanceInKm * 1000;
    }
}
