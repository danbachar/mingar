const parse = require('pg-connection-string').parse;

let config = {
  name: 'default',
  type: 'postgres',
  host: 'localhost',
  port: 5432,
  username: 'mingar',
  password: 'mingar',
  database: 'mingar',
  synchronize: true,
  schema: 'public',
  extra: {
    ssl: process.env.POSTGRES_SSL == 'true' ? true : false
  },
  logging: false,
  entities: ["src/**/*.entity{.ts,.js}"],
  migrations: ["src/migrations/**/*{.ts,.js}"],
  cli: {
    "entitiesDir": "src/entity",
    "migrationsDir": "src/migrations"
  }
};

if (process.env.NODE_ENV === 'test') {
  const id = +process.env.JEST_WORKER_ID || '0';
  config.schema = 'test' + id;
}

if (process.env.DATABASE_URL != null) {

  const options = parse(process.env.DATABASE_URL);

  config.host = options.host;
  config.port = options.port;
  config.username = options.user;
  config.password = options.password;
  config.database = options.database;
}

module.exports = config;
