import { LocationDTO } from './../DTO/location.dto';
import { Injectable } from '@nestjs/common';
import { sqrt,cos } from 'mathjs'
import {POI} from "../entity/poi.entity";
import {PoiService} from "./poi.service";

@Injectable()
export class LocationService {

    constructor(private readonly poiService: PoiService) { }

    public calculateDistance(location1: LocationDTO, location2: LocationDTO): number {
        let lat =  (location1.lat - location2.lat) / 2 * 0.01745;
        let dx = 111.3 * cos(lat) * (location1.long - location2.long);
        let dy = 111.3 * (location1.lat - location2.lat)
        return sqrt(dx * dx + dy * dy);
    }

    public async getNearestPois(myLocation: LocationDTO): Promise<POI[]> {
        // change to getallPois
        const listOfPois = await this.poiService.getAll();

        const sortedArray = listOfPois.sort((n1, n2) => {
            const n1Location = new LocationDTO(n1.lat, n1.long);
            const n2Location = new LocationDTO(n2.lat, n2.long);

            return this.calculateDistance(myLocation, n1Location) - this.calculateDistance(myLocation, n2Location);
        });


        return sortedArray;
    }
}
