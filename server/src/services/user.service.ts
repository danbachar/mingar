import { Repository } from 'typeorm';
import { User } from '../entity/user.entity';
import { Inject } from '@nestjs/common';
import { DbConstants } from 'consts/db.consts';

export class UserService {
    constructor(@Inject(DbConstants.USER_REPOSITORY) private readonly userRepo: Repository<User>) { }

    getUserById(id: string): Promise<User|undefined> {
        return this.userRepo.findOne(id);
    }
}