import { POI } from './poi.entity';
import { Entity, ManyToOne, PrimaryGeneratedColumn, Column } from 'typeorm';
import { User } from './user.entity';

@Entity()
export class Note {
    @PrimaryGeneratedColumn()
    public id: string;

    @ManyToOne(type => User, user => user.notes)
    public creatingUser: User;

    @Column()
    public text: string;

    @ManyToOne(() => POI, poi => poi.notes)
    public poi: POI;
}