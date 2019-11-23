import { Module } from '@nestjs/common';
import { dbProviders } from '../providers/db.providers';

@Module({
    imports: [ ],
    providers: [...dbProviders],
    exports: [...dbProviders],
})
export class DbModule {}
