import { LocationDTO } from './../DTO/location.dto';
import { Injectable } from '@nestjs/common';

@Injectable()
export class LocationService {

    public calculateDistance(location1: LocationDTO, location2: LocationDTO): number {
        // TODO
        return 0;
    }
}
