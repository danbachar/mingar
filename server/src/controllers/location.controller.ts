import { LocationDTO } from './../DTO/location.dto';
import { LocationService } from './../services/location.service';
import { Controller, Body, Post, Param, ParseIntPipe } from '@nestjs/common';
import { POI } from 'entity/poi.entity';
import { aquamarine } from 'color-name';

@Controller('/api/location')
export class LocationController {
    constructor(private readonly locationService: LocationService) { }
}