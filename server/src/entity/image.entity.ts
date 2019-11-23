import { POI } from './poi.entity';
import { File } from './file.entity';
import { OneToOne, PrimaryGeneratedColumn, Entity, ManyToOne } from 'typeorm';

@Entity()
export class Image {
    @PrimaryGeneratedColumn('uuid')
    public id: string;

    @OneToOne(() => File)
    public file: File;

    @ManyToOne(type => POI, poi => poi.images)
    public poi: POI;

    // achievement?
}