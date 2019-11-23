import { Achievment } from '../entity/achievment.entity';
import { PoiService } from '../services/poi.service';
import { Controller, Get, Post, Body, Param, Res } from '@nestjs/common';
import { POI } from '../entity/poi.entity';
import { LocationDTO } from 'DTO/location.dto';
import { AchievmentService } from '../services/achievment.service';
import { Response } from 'express';

@Controller('/api/poi')
export class PoiController {
    constructor(private readonly poiService: PoiService,
                private readonly achievmentServie: AchievmentService) {}

  @Get()
  getAll(): Promise<POI[]> {
    return this.poiService.getAll();
  }

  @Post(':radius')
    getNearestPoints(@Param('radius') radius: number, @Body() location: LocationDTO): Promise<POI[]> {
        return this.poiService.getNearestPois(location, radius);
    }

    @Post('visit/:id')
    async markPOIAsVisited(
      @Param('id') id: string, @Body() location: LocationDTO, @Body() poisVisited: string[], @Res() res: Response): Promise<Achievment[]> {
      const canVisitPOI = await this.poiService.canVisitPOI(id, location);

      if (!canVisitPOI) {
        res.status(403).send('POI cannot be visited');
        return;
      }

      const achievmentsUnlocked: Achievment[] = [];

      const allAchievments = await this.achievmentServie.getAllAchievments();

      const allSpecificAchievments = allAchievments.filter(achv => achv.achievmentType === ACHIEVMENT.Specific);

      poisVisited.push(id);
      poisVisited.sort();
      // check if any POI-specific achievments were unlocked
      allSpecificAchievments.map(specificAchievment => {
        if (specificAchievment.pois.length === poisVisited.length) {
          const sortedPoiIdsPerAchievment = specificAchievment.pois.map(poi => poi.id).sort();
          let allPOIsForAchievmentVisited = true;

          for (let index = 0; index < sortedPoiIdsPerAchievment.length; index++) {
            if (sortedPoiIdsPerAchievment[index] !== poisVisited[index]) {
              allPOIsForAchievmentVisited = false;
              break;
            }
          }

          if (allPOIsForAchievmentVisited) {
            achievmentsUnlocked.push(specificAchievment);
          }
        }
      });

      const allPois = await this.poiService.getAll();
      const allCountAchievments = allAchievments.filter(achv => achv.achievmentType === ACHIEVMENT.Count);


      allCountAchievments.map(countAchievment => {
        if (poisVisited.length >= countAchievment.requiredNumberOfPOIs) {
          achievmentsUnlocked.push(countAchievment);
        }
      });

      return achievmentsUnlocked;
    }
}