import { User } from './../entity/user.entity';
import { Note } from './../entity/note.entity';
import { Model } from './../entity/model.entity';
import { Image } from './../entity/image.entity';
import { File } from './../entity/file.entity';
import { Achievement } from './../entity/achievement.entity';
import { DbConstants } from 'consts/db.consts';
import { PostgresConnectionOptions } from 'typeorm/driver/postgres/PostgresConnectionOptions';
import { getConnectionOptions, createConnection, Connection } from 'typeorm';
import { LoggerFactory } from '../utils/LoggerFactory';
import { POI } from 'entity/poi.entity';

const logger = LoggerFactory(module);

export const dbProviders = [
    {
        provide: DbConstants.DB_CONNECTION,
        useFactory: async () => {

          const options = (await getConnectionOptions()) as PostgresConnectionOptions;

          logger.debug(`Creating db connection to postgres://${options.host}:${options.port}/${options.database}.${options.schema}`);

          const connection = await createConnection(options);
          return connection;
        }
    },
    {
        provide: DbConstants.ACHIEVEMENT_REPOSITORY,
        useFactory: (connection: Connection) => connection.getRepository(Achievement),
        inject: [DbConstants.DB_CONNECTION],
    },
    {
        provide: DbConstants.FILE_REPOSITORY,
        useFactory: (connection: Connection) => connection.getRepository(File),
        inject: [DbConstants.DB_CONNECTION],
    },
    {
        provide: DbConstants.IMAGE_REPOSITORY,
        useFactory: (connection: Connection) => connection.getRepository(Image),
        inject: [DbConstants.DB_CONNECTION],
    },
    {
        provide: DbConstants.MODEL_REPOSITORY,
        useFactory: (connection: Connection) => connection.getRepository(Model),
        inject: [DbConstants.DB_CONNECTION],
    },
    {
        provide: DbConstants.NOTE_REPOSITORY,
        useFactory: (connection: Connection) => connection.getRepository(Note),
        inject: [DbConstants.DB_CONNECTION],
    },
    {
        provide: DbConstants.POI_REPOSITORY,
        useFactory: (connection: Connection) => connection.getRepository(POI),
        inject: [DbConstants.DB_CONNECTION],
    },
    {
        provide: DbConstants.USER_REPOSITORY,
        useFactory: (connection: Connection) => connection.getRepository(User),
        inject: [DbConstants.DB_CONNECTION],
    }
];