import { Entity, ManyToOne, PrimaryGeneratedColumn, Column } from 'typeorm';
import { User } from './user.entity';

@Entity()
export class Note {
    @PrimaryGeneratedColumn('uuid')
    public id: string;

    @ManyToOne(type => User, user => user.notes)
    public creatingUser: User;

    @Column()
    public title: string;

    @Column()
    public description: string;

    @Column({type: 'double precision'})
    public lat: number;

    @Column({type: 'double precision'})
    public long: number;

    @Column({type: 'double precision'})
    public attitude: number;
}