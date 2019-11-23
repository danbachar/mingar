import { Controller, Get, Post, Body } from '@nestjs/common';
import { AchievementService } from '../services/achievement.service';
import { Achievement } from '../entity/achievement.entity';

@Controller('/api/achievement')
export class AchievementController {
    constructor(private readonly achievementService: AchievementService) { }

    @Get()
    getAll(): Promise<Achievement[]> {
        return this.achievementService.getAllAchievements();
    }

    @Post()
    createAchievement(@Body() achievement: Achievement): Promise<Achievement> {
        return this.achievementService.createAchievement(achievement);
    }
}