import { PoiService } from '../services/poi.service';
import { Controller, Get } from '@nestjs/common';
import { POI } from 'entity/poi.entity';

@Controller('/api/poi')
export class PoiController {
    constructor(private readonly poiService: PoiService) {}

  @Get()
  getAll(): Promise<POI[]> {
    return this.poiService.getAll();
  }
  @Post(':radius')
    getNearestPoints(@Param('radius') radius: number, @Body() location: LocationDTO): Promise<POI[]> {
        return this.poiService.getNearestPois(location, radius);
    }
