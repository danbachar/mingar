import { Test, TestingModule } from '@nestjs/testing';
import { PoiService } from './poi.service';

describe('PoiService', () => {
  let service: PoiService;
  beforeAll(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [PoiService],
    }).compile();
    service = module.get<PoiService>(PoiService);
  });
  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
