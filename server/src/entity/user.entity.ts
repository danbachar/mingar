import { POI } from './poi.entity';
import { Achievement } from './achievement.entity';
import { Entity, PrimaryGeneratedColumn, Column, OneToMany, ManyToMany, JoinTable } from 'typeorm';
import { Note } from './note.entity';

@Entity()
export class User {
    @PrimaryGeneratedColumn('uuid')
    public id: string;

    @Column({ unique: true })
    public name: string;

    @Column()
    public score: number;

    @Column()
    public password: string;

    @Column({type: 'double precision'})
    public lat: number;

    @Column({type: 'double precision'})
    public long: number;

    @OneToMany(type => Note, note => note.creatingUser)
    public notes: Note[];

    @ManyToMany(type => Achievement)
    @JoinTable()
    public achievements: Achievement[];

    @ManyToMany(() => POI, poi => poi.usersVisited)
    @JoinTable()
    public locationHistory: POI[];
}