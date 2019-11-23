import { LocationDTO } from './../DTO/location.dto';
import { Injectable } from '@nestjs/common';
import { sqrt, cos } from 'mathjs';
import { POI } from '../entity/poi.entity';
import { PoiService } from './poi.service';

@Injectable()
export class LocationService {

    constructor(private readonly poiService: PoiService) { }

    public calculateDistance(location1: LocationDTO, location2: LocationDTO): number {
        const lat =  (location1.lat - location2.lat) / 2 * 0.01745;
        const dx = 111.3 * cos(lat) * (location1.long - location2.long);
        const dy = 111.3 * (location1.lat - location2.lat);

        return sqrt(dx * dx + dy * dy);
    }

    public async getNearestPois(myLocation: LocationDTO, withinRadiusInMeters: number): Promise<POI[]> {
        // change to getallPois
        const listOfPois = await this.poiService.getAll();

        const filteredArray = listOfPois.filter((poi) => {
            const currentLocation = new LocationDTO(poi.lat, poi.long);
            const poiLocation = new LocationDTO(poi.lat, poi.long);

            const distance = Math.abs(this.calculateDistance(myLocation, poiLocation)) * 1000; // this gives back km, convert to meters

            return distance <= withinRadiusInMeters;
        });

        const sortedArray = filteredArray.sort((n1, n2) => {
            const n1Location = new LocationDTO(n1.lat, n1.long);
            const n2Location = new LocationDTO(n2.lat, n2.long);

            return this.calculateDistance(myLocation, n1Location) - this.calculateDistance(myLocation, n2Location);
        });

        return sortedArray;
    }
}
