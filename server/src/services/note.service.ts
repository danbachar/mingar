import { LocationService } from './location.service';
import { LocationDTO } from '../DTO/location.dto';
import { Note } from '../entity/note.entity';
import { Inject } from '@nestjs/common';
import { DbConstants } from 'consts/db.consts';
import { Repository } from 'typeorm';
import { User } from '../entity/user.entity';
import { UserService } from './user.service';

export class NoteService {
    constructor(@Inject(DbConstants.NOTE_REPOSITORY) private readonly noteRepo: Repository<Note>,
                private readonly locationService: LocationService,
                private readonly userService: UserService) { }

    getAll(): Promise<Note[]> {
        return this.noteRepo.find();
    }

    async findWithinRadiusInMeters(userLocation: LocationDTO, radius: number): Promise<Note[]> {
        const allNotes = await this.getAll();

        const notesInRange = allNotes.filter((note) => {
            const noteLocation: LocationDTO = { long: note.long, lat: note.lat };

            const distanceToUser = this.locationService.calculateDistanceInMeters(userLocation, noteLocation);

            return distanceToUser <= radius;
        });

        return notesInRange;
    }

    async createNewNote(creatingUserId: string, title: string, description: string, long: number, lat: number, attitude: number): Promise<Note> {
        const creatingUser = await this.userService.getUserById(creatingUserId);
        if (!creatingUser) {
            return null;
        }

        // TODO: needed?
        const note = new Note();
        note.title = title;
        note.description = description;
        note.long = long;
        note.lat = lat;
        note.attitude = attitude;
        note.creatingUser = creatingUser;

        return this.noteRepo.save(note);
    }

    async deleteNote(id: string): Promise<boolean> {
        // TODO: needed?

        const note = await this.noteRepo.findOne(id);

        if (!note) {
            return false;
        }

        await this.noteRepo.remove(note);

        return true;
    }
}