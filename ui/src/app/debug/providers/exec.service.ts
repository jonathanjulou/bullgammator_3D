import { Injectable } from '@angular/core';

import { Execution } from 'bullgammator';
import { BullgammatorService } from '../../providers/bullgammator.service';

@Injectable()
export class ExecService {

	exec: Execution;

  constructor(
    private bull: BullgammatorService
  ) {
		this.exec = new Execution(this.bull.bullgamma);
	}

	executeNextInstruction() {
		this.exec.executeNextInstruction();
	}

	executeUntil(line: number, seriesId: number) {
		for (i=0; i<64; i++){
			this.exec.executeNextInstruction();
		}
	}

	getLine() {
		return this.exec.getCurrentLine();
	}

	getSeries() {
		return this.exec.getCurrentSeries();
	}

	getNumberOfSeries() {
		return this.bull.constants.NB_SERIES;
	}

	getConsoleLines() {
		return this.exec.console.getLines();
	}

	writeConsoleLine(line: string) {
		this.exec.writeConsoleLine(line);
	}
}
