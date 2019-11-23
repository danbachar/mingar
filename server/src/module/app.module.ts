import { AchievmentService } from './../services/achievment.service';
import { LocationController } from './../controllers/location.controller';
import { PoiService } from './../services/poi.service';
import { PoiController } from './../controllers/poi.controller';
import { DbModule } from './db.module';
import { Module } from '@nestjs/common';
import { AppController } from '../controllers/app.controller';
import { AppService } from '../services/app.service';
import { LocationService } from '../services/location.service';

@Module({
  imports: [ DbModule ],
  controllers: [AppController, PoiController, LocationController],
  providers: [AppService, PoiService, LocationService, AchievmentService],
})
export class AppModule {}
