import { NestFactory } from '@nestjs/core';
import { AppModule } from './module/app.module';
import { LoggerFactory } from './utils/LoggerFactory';

const logger = LoggerFactory(module);

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const PORT = process.env.$PORT || process.env.PORT || 3000;
  await app.listen(PORT);
  logger.info('Application started and running on port ' + PORT + '!');
}
bootstrap();
