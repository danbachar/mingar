import { LocationDTO } from './../DTO/location.dto';
import { Injectable } from '@nestjs/common';
import { sqrt,cos } from 'mathjs'

@Injectable()
export class LocationService {

    public calculateDistance(location1: LocationDTO, location2: LocationDTO): number {
        let lat =  (location1.lat - location2.lat) / 2 * 0.01745;
        let dx = 111.3 * cos(lat) * (location1.long - location2.long);
        let dy = 111.3 * (location1.lat - location2.lat)
        return sqrt(dx * dx + dy * dy);
    }

    public getNearestPois(myLocation: LocationDTO)
}
