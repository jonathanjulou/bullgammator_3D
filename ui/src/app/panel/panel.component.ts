import { Component, OnInit } from '@angular/core';
import { PanelService } from './providers/panel.service';
import { BullgammatorService } from '../providers/bullgammator.service';

@Component({
  selector: 'app-panel',
  templateUrl: './panel.component.html',
  styleUrls: ['./panel.component.css']
})
export class PanelComponent implements OnInit {

  constructor(
	) { }

  ngOnInit() {
  }

}
