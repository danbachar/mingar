import { Achievement } from '../entity/achievement.entity';
import { PoiService } from '../services/poi.service';
import { Controller, Get, Post, Body, Param, Res, Req, Put, Patch } from '@nestjs/common';
import { POI } from '../entity/poi.entity';
import { LocationDTO } from 'DTO/location.dto';
import { AchievementService } from '../services/achievement.service';
import { Response, Request } from 'express';
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
    @Param('id') id: string, @Req() req: Request, @Res() res: Response): Promise<Achievement[]> {
      const body = req.body as { long: number, lat: number, poisVisited: string[] }; // because transmitting primal type(-arrays) is shit in nest
      const location: LocationDTO = { long: body.long, lat: body.lat };

      const canVisitPOI = await this.poiService.canVisitPOI(id, location);

      if (!canVisitPOI) {
        res.status(403).send('POI cannot be visited');
        return;
      }

      const achievementsUnlocked: Achievement[] = [];

      const allAchievements = await this.achievementServie.getAllAchievements();

      const allSpecificAchievements = allAchievements.filter(achv => achv.achievementType === ACHIEVEMENT.Specific);

      body.poisVisited.push(id);
      body.poisVisited.sort();

      // check if any POI-specific achievements were unlocked
      allSpecificAchievements.map(specificAchievement => {
        if (specificAchievement.pois.length === body.poisVisited.length) {
          const sortedPoiIdsPerAchievement = specificAchievement.pois.map(poi => poi.id).sort();
          let allPOIsForAchievementVisited = true;

          for (let index = 0; index < sortedPoiIdsPerAchievement.length; index++) {
            if (sortedPoiIdsPerAchievement[index] !== body.poisVisited[index]) {
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

      // check if any count-based achievements were unlocked
      allCountAchievements.map(countAchievement => {
        if (body.poisVisited.length >= countAchievement.requiredNumberOfPOIs) {
          achievementsUnlocked.push(countAchievement);
        }
      });

      res.status(200).send(achievementsUnlocked);
  }

  @Patch(':id')
  rankPOI(@Param('id')id: string, @Req() req: Request): Promise<POI> {
    const body = req.body as { rank: number|string }; // because nest sucks with transmitting primal values in the body
    // tslint:disable-next-line:radix
    return this.poiService.rankPOI(id, parseInt(body.rank as string));
  }
}