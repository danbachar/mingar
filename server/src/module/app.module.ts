import { DbModule } from './db.module';
import { AchievementController } from '../controllers/achievement.controller';
import { AchievementService } from '../services/achievement.service';
import { LocationController } from '../controllers/location.controller';
import { PoiService } from '../services/poi.service';
import { PoiController } from '../controllers/poi.controller';
import { AppController } from '../controllers/app.controller';
import { AppService } from '../services/app.service';
import { LocationService } from '../services/location.service';
import { Module } from '@nestjs/common';

@Module({
  imports: [ DbModule ],
  controllers: [AppController, PoiController, LocationController, AchievementController],
  providers: [AppService, PoiService, LocationService, AchievementService],
})
export class AppModule {}
