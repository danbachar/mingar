import { Achievement } from './../entity/achievement.entity';
import { Inject } from '@nestjs/common';
import { DbConstants } from 'consts/db.consts';
import { Repository } from 'typeorm';
import { POI } from 'entity/poi.entity';

export class AchievementService {

    constructor(@Inject(DbConstants.ACHIEVEMENT_REPOSITORY) private readonly achievementRepo: Repository<Achievement>) { }

    public getAllAchievements(): Promise<Achievement[]> {
        return this.achievementRepo.find();
    }
}