import { Get, Controller } from '@nestjs/common';

@Controller()
export class AppController {

  @Get()
  ping(): string {
    return 'pong';
  }
}
