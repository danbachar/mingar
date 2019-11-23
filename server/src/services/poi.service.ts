import { LocationDTO } from './../DTO/location.dto';
import { LocationService } from './location.service';
import { DbConstants } from './../consts/db.consts';
import { Injectable, Inject } from '@nestjs/common';
import { Repository } from 'typeorm';
import { POI } from '../entity/poi.entity';

@Injectable()
export class PoiService {
    constructor(@Inject(DbConstants.POI_REPOSITORY) private readonly poiRepo: Repository<POI>) { }

    async getAll(): Promise<POI[]> {
        return this.poiRepo.find();
    }

    async createNewPoi(title: string, description: string, lat: number, long: number): Promise<POI> {
        const poi = new POI();
        poi.title = title;
        poi.description = description;
        poi.long = long;
        poi.lat = lat;

        return this.poiRepo.save(poi);
    }

    public async getNearestPois(myLocation: LocationDTO, withinRadiusInMeters: number): Promise<POI[]> {
        // change to getallPois
        const listOfPois = await this.getAll();

        const filteredArray = listOfPois.filter((poi) => {
            const poiLocation = new LocationDTO(poi.lat, poi.long);

            const distance =
                Math.abs(this.locationService.calculateDistance(myLocation, poiLocation))
                    * 1000; // this gives back km, convert to meters

            return distance <= withinRadiusInMeters;
        });

        const sortedArray = filteredArray.sort((n1, n2) => {
            const n1Location = new LocationDTO(n1.lat, n1.long);
            const n2Location = new LocationDTO(n2.lat, n2.long);

            return this.locationService.calculateDistance(myLocation, n1Location) - this.locationService.calculateDistance(myLocation, n2Location);
        });

        return sortedArray;
    }
