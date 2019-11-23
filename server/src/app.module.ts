import { Module } from '@nestjs/common';
import { AppController } from './controllers/app.controller';
import { AppService } from './services/app.service';
import { LocationService } from './services/location.service';

@Module({
  imports: [],
  controllers: [AppController],
  providers: [AppService, LocationService],
})
export class AppModule {}
