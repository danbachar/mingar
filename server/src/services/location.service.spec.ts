import { Test, TestingModule } from '@nestjs/testing';
import { Location.Service.TsService } from './location.service.ts.service';

describe('Location.Service.TsService', () => {
  let service: Location.Service.TsService;
  beforeAll(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [Location.Service.TsService],
    }).compile();
    service = module.get<Location.Service.TsService>(Location.Service.TsService);
  });
  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
