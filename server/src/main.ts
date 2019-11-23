import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { LoggerFactory } from './utils/LoggerFactory';

const logger = LoggerFactory(module);

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  await app.listen(3000);
  logger.info('Application started and running on port 3000!');
}
bootstrap();
