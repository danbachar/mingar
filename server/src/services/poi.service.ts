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
}
