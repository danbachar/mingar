import { LocationDTO } from './../DTO/location.dto';
import { Injectable } from '@nestjs/common';
import { sqrt, cos } from 'mathjs';
import { POI } from '../entity/poi.entity';
import { PoiService } from './poi.service';

@Injectable()
export class LocationService {
    public calculateDistance(location1: LocationDTO, location2: LocationDTO): number {
        const diff = Math.abs(location1.lat - location2.lat);

        const lat =   diff / 2 * 0.01745;
        const dx = 111.3 * cos(lat) * (diff);
        const dy = 111.3 * diff;

        return sqrt(dx * dx + dy * dy);
    }
}
