assert = require('assert')

const NB_MEMORIES_PER_OCTAD = require("../constants").NB_MEMORIES_PER_OCTAD
const NB_BANAL_MEMORIES = require("../constants").NB_BANAL_MEMORIES
const NB_HEX_VALUES_PER_OCTAD = require("../constants").NB_HEX_VALUES_PER_OCTAD
const NB_CHRS_PER_WORD = require("../constants").NB_CHRS_PER_WORD

Memory = require("./memory").Memory

class Octad {
  constructor(id, bullGamma) {
    this.id = id;
    this.memories = new Array(NB_MEMORIES_PER_OCTAD);
    for (let i = 0; i < NB_MEMORIES_PER_OCTAD; ++i) {
      this.memories[i] = new Memory(NB_BANAL_MEMORIES + i, bullGamma)
    }
  }

	/**
	 * Returns the memory corresponding to the id
	 * @param id from 0 to 7
	 */
  getMemory(idx) {
    return this.memories[idx];
  }

  setContent(hexCode) {
    hexCode = hexCode.replace(/[\s\n\r\t]/g, ''); // remove white space and line breaks
    assert(hexCode.length === NB_HEX_VALUES_PER_OCTAD, "hexCode should be of length " + NB_HEX_VALUES_PER_OCTAD)
    for (let i = 0; i < NB_MEMORIES_PER_OCTAD; ++i) {
      this.getMemory(i).setContent(hexCode.substr(i*NB_CHRS_PER_WORD, NB_CHRS_PER_WORD))
    }
  }

  toString() {
    let str = ""
    this.memories.forEach(function(memory) {
      str += memory.toString() + "\n"
    })
    return str
  }
}

module.exports.Octad = Octad;