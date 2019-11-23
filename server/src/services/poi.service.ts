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
}
