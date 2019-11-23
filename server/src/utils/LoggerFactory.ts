import * as winston from 'winston';
import * as path from 'path';

winston.addColors({
  silly: 'magenta',
  debug: 'blue',
  verbose: 'cyan',
  info: 'green',
  warn: 'yellow',
  error: 'red',
});

// when running in TEST mode, increase level to WARN
const defaultLevel = process.env.NODE_ENV === 'test' ? 'warn' : 'debug';

// set root directory to correctly resolve module path names
const rootDirectory = path.resolve(path.join(__dirname, '..'));

function LoggerFactory(module: NodeModule) {

  const id = path.resolve(module.filename).substr(rootDirectory.length + 1);

  const customFormat = winston.format.printf((info) => {
    return `${id} ${info.level} ${info.message}`;
  });

  const logger = winston.createLogger({
    levels: winston.config.npm.levels,
    format: winston.format.combine(
      winston.format.colorize(),
      winston.format.timestamp(),
      customFormat,
    ),
    transports: [
      new winston.transports.Console({
        level: defaultLevel,
      }),
    ],
  });

  return logger;
}

export { LoggerFactory };
