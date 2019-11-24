import { Model } from './model.entity';
import { Achievement } from './achievement.entity';
import { Image } from './image.entity';
import { Entity, PrimaryGeneratedColumn, Column, OneToMany, ManyToMany, JoinTable, OneToOne } from 'typeorm';
import { User } from './user.entity';
import { Note } from './note.entity';

@Entity()
export class POI {
    @PrimaryGeneratedColumn('uuid')
    public id: string;

    @Column({ unique: true })
    public title: string;

    @Column()
    public description: string;

    @OneToMany( () => Image, img => img.poi)
    public images: Image[];

    @Column({type: 'double precision'})
    public lat: number;

    @Column({type: 'double precision'})
    public long: number;

    @Column({type: 'double precision', default: -1 })
    public ranking: number;

    @ManyToMany(() => Achievement, achv => achv.pois)
    @JoinTable()
    public achievements: Achievement[];

    @ManyToMany(() => User, user => user.locationHistory)
    public usersVisited: User[];

    @OneToOne(() => Note)
    public notes: Note[];

    @OneToOne(() => Model)
    public model: Model;
}