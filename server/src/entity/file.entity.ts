import { Column, Entity, PrimaryGeneratedColumn } from 'typeorm';

@Entity()
export class File {
    @PrimaryGeneratedColumn('uuid')
    public id: string;

    @Column()
    public name: string;
}