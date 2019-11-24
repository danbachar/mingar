const parse = require('pg-connection-string').parse;

let config = {
  name: 'default',
  type: 'postgres',
  host: 'ec2-54-75-238-138.eu-west-1.compute.amazonaws.com',
  port: 5432,
  username: 'dfnfhecrmnapyr',
  password: '2fa24829aa853ad93aa9c4dff11b74d0e84489d6c934058ab886d5b06d9e7eb1',
  database: 'ddltmclcequcb0',
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
