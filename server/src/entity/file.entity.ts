import { Column, Entity, PrimaryGeneratedColumn } from 'typeorm';

@Entity()
export class File {
    @PrimaryGeneratedColumn()
    public id: string;

    @Column()
    public name: string;
}