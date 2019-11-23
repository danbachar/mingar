import { Achievement } from '../entity/achievement.entity';
import { PoiService } from '../services/poi.service';
import { Controller, Get, Post, Body, Param, Res } from '@nestjs/common';
import { POI } from '../entity/poi.entity';
import { LocationDTO } from 'DTO/location.dto';
import { AchievementService } from '../services/achievement.service';
import { Response } from 'express';
import { ACHIEVEMENT} from '../enum/achievement-type.enum';

@Controller('/api/poi')
export class PoiController {
    constructor(private readonly poiService: PoiService,
                private readonly achievementServie: AchievementService) {}

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
      @Param('id') id: string, @Body() location: LocationDTO, @Body() poisVisited: string[], @Res() res: Response): Promise<Achievement[]> {
      const canVisitPOI = await this.poiService.canVisitPOI(id, location);

      if (!canVisitPOI) {
        res.status(403).send('POI cannot be visited');
        return;
      }

      const achievementsUnlocked: Achievement[] = [];

      const allAchievements = await this.achievementServie.getAllAchievements();

      const allSpecificAchievements = allAchievements.filter(achv => achv.achievementType === ACHIEVEMENT.Specific);

      poisVisited.push(id);
      poisVisited.sort();
      // check if any POI-specific achievements were unlocked
      allSpecificAchievements.map(specificAchievement => {
        if (specificAchievement.pois.length === poisVisited.length) {
          const sortedPoiIdsPerAchievement = specificAchievement.pois.map(poi => poi.id).sort();
          let allPOIsForAchievementVisited = true;

          for (let index = 0; index < sortedPoiIdsPerAchievement.length; index++) {
            if (sortedPoiIdsPerAchievement[index] !== poisVisited[index]) {
              allPOIsForAchievementVisited = false;
              break;
            }
          }

          if (allPOIsForAchievementVisited) {
            achievementsUnlocked.push(specificAchievement);
          }
        }
      });

      const allCountAchievements = allAchievements.filter(achv => achv.achievementType === ACHIEVEMENT.Count);

      allCountAchievements.map(countAchievement => {
        if (poisVisited.length >= countAchievement.requiredNumberOfPOIs) {
          achievementsUnlocked.push(countAchievement);
        }
      });

      return achievementsUnlocked;
    }
}