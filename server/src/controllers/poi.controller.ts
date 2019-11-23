import { PoiService } from '../services/poi.service';
import { Controller, Get } from '@nestjs/common';
import { POI } from 'entity/poi.entity';

@Controller()
export class PoiController {
    constructor(private readonly poiService: PoiService) {}

  @Get()
  getAll(): Promise<POI[]> {
    return this.poiService.getAll();
  }
}
