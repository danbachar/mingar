import { POI } from './poi.entity';
import { Image } from './image.entity';
import { Entity, PrimaryGeneratedColumn, Column, OneToOne, ManyToMany } from 'typeorm';

@Entity()
export class Achievment {
    @PrimaryGeneratedColumn('uuid')
    public id: string;

    @Column()
    public title: string;

    @Column()
    public description: string;

    @OneToOne(() => Image)
    public image: Image;

    @ManyToMany(() => POI, poi => poi.achievments)
    public pois: POI[];
}