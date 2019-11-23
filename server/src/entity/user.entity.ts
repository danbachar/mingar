import { POI } from './poi.entity';
import { Achievment } from './achievment.entity';
import { Entity, PrimaryGeneratedColumn, Column, OneToMany, ManyToMany, JoinTable } from 'typeorm';
import { Note } from './note.entity';

@Entity()
export class User {
    @PrimaryGeneratedColumn()
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

    @ManyToMany(type => Achievment)
    @JoinTable()
    public achievments: Achievment[];

    @ManyToMany(() => POI, poi => poi.usersVisited)
    @JoinTable()
    public locationHistory: POI[];
}