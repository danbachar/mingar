import { POI } from './poi.entity';
import { Image } from './image.entity';
import { Entity, PrimaryGeneratedColumn, Column, OneToOne, ManyToMany } from 'typeorm';

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

    @Column({ default: 0 })
    public achievementType: number;

    @Column()
    public requiredNumberOfPOIs: number;
}