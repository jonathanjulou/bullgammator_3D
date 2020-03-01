import { Injectable } from '@angular/core';
import { BullgammatorService } from '../../providers/bullgammator.service';

@Injectable()
export class PanelService {

  constructor(
    private bull: BullgammatorService
  ) { }

}
