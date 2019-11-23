import { CreateNoteDTO } from './../DTO/createNote.dto';
import { Controller, Get, Post, Param, Body } from '@nestjs/common';
import { NoteService } from '../services/note.service';
import { Note } from '../entity/note.entity';
import { LocationDTO } from '../DTO/location.dto';

@Controller('/api/note')
export class NoteController {
    constructor(private readonly noteService: NoteService) { }

    @Get()
    getAll(): Promise<Note[]> {
        return this.noteService.getAll();
    }

    @Post(':radius')
    getAllWithinRadius(@Param('radius') radius: number, @Body() location: LocationDTO): Promise<Note[]> {
        return this.noteService.findWithinRadiusInMeters(location, radius);
    }

    @Post()
    createNote(@Body() createNoteDto: CreateNoteDTO): Promise<Note> {
        return this.noteService.createNewNote(
            createNoteDto.creatingUser, createNoteDto.title, createNoteDto.description,
            createNoteDto.long, createNoteDto.lat, createNoteDto.attitude);
    }
}