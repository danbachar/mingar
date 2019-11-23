import { POI } from './poi.entity';
import { Image } from './image.entity';
import { Entity, PrimaryGeneratedColumn, Column, OneToOne, ManyToMany } from 'typeorm';
import { ACHIEVEMENT } from '../enum/achievement-type.enum';

@Entity()
export class Achievement {
    @PrimaryGeneratedColumn('uuid')
    public id: string;

    @Column()
    public title: string;

    @Column()
    public description: string;

    @OneToOne(() => Image)
    public image: Image;

    @ManyToMany(() => POI, poi => poi.achievements)
    public pois: POI[];

    @Column({ default: ACHIEVEMENT.Count })
    public achievementType: ACHIEVEMENT;

    @Column()
    public requiredNumberOfPOIs: number;
}