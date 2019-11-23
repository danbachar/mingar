import { Achievment } from './../entity/achievment.entity';
import { Inject } from '@nestjs/common';
import { DbConstants } from 'consts/db.consts';
import { Repository } from 'typeorm';
import { POI } from 'entity/poi.entity';

export class AchievmentService {

    constructor(@Inject(DbConstants.ACHIEVMENT_REPOSITORY) private readonly achievmentRepo: Repository<Achievment>) { }

    public getAllAchievments(): Promise<Achievment[]> {
        return this.achievmentRepo.find();
    }
}