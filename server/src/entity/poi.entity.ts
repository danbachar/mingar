import { Model } from './model.entity';
import { Achievment } from './achievment.entity';
import { Image } from './image.entity';
import { Entity, PrimaryGeneratedColumn, Column, OneToMany, ManyToMany, JoinTable, OneToOne } from 'typeorm';
import { User } from './user.entity';
import { Note } from './note.entity';

@Entity()
export class POI {
    @PrimaryGeneratedColumn()
    public id: string;

    @Column({ unique: true })
    public title: string;

    @Column()
    public description: number;

    @OneToMany( () => Image, img => img.poi)
    public images: Image[];

    @Column({type: 'double precision'})
    public lat: number;

    @Column({type: 'double precision'})
    public long: number;

    @Column({type: 'double precision'})
    public ranking: number;

    @ManyToMany(() => Achievment, achv => achv.pois)
    @JoinTable()
    public achievments: Achievment[];

    @ManyToMany(() => User, user => user.locationHistory)
    public usersVisited: User[];

    @OneToMany(() => Note, note => note.poi)
    public notes: Note[];

    @OneToOne(() => Model)
    public model: Model;
}