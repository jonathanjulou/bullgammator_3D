BullGamma = require("../../../machine/bullGamma").BullGamma;
MEMORY_MODE = require("../../../machine/bullGamma").MEMORY_MODE;
assert = require('assert');
AN = require("../../../assembly/AN").AN;
Memory = require("../../../machine/memory").Memory;

describe('AN', function() {
  describe('#execute()', function () {
    it('should add when M1 and MB are positive', function () {
      let bullGamma = new BullGamma();
      let m1 = bullGamma.getMemory(1);
      let m2 = bullGamma.getMemory(2);
      let od = 0, of = 8;
      for (let i = od; i < of; ++i) {
        m1.blocks[i] = 9
        m2.blocks[i] = 9
      }
      new AN(2, 0, 8, bullGamma).execute()
      let total = 0
      for (let i = 0; i < 12; ++i) {
        total += m1.blocks[i]*10**i
      }
      assert.equal(total, 199999998, "wrong result")
    });
    it('should add when M1 and MB are negative', function () {
      let bullGamma = new BullGamma();
      let m1 = bullGamma.getMemory(1);
      let m2 = bullGamma.getMemory(2);
      let od = 0, of = 8;
      for (let i = od; i < of; ++i) {
        m1.blocks[i] = 9
        m2.blocks[i] = 9
      }
      m2.blocks[of - 1] = 10
      bullGamma.ms1 = 10
      new AN(2, 0, 8, bullGamma).execute()
      let total = 0
      for (let i = 0; i < 12; ++i) {
        total += m1.blocks[i]*10**i
      }
      assert.equal(total, 109999998, "wrong result")
      assert.equal(bullGamma.ms1, 10, "wrong sign")
    });
    it('should add when M1 is positive and MB is negative', function () {
      let bullGamma = new BullGamma();
      let m1 = bullGamma.getMemory(1);
      let m2 = bullGamma.getMemory(2);
      let od = 0, of = 8;
      for (let i = od; i < of; ++i) {
        m1.blocks[i] = 9
        m2.blocks[i] = 9
      }
      m2.blocks[of - 1] = 10
      new AN(2, 0, 8, bullGamma).execute()
      let total = 0
      for (let i = 0; i < 12; ++i) {
        total += m1.blocks[i]*10**i
      }
      assert.equal(total, 90000000, "wrong result")
    });
    it('should add when M1 is negative and MB is positive', function () {
      let bullGamma = new BullGamma();
      let m1 = bullGamma.getMemory(1);
      let m2 = bullGamma.getMemory(2);
      let od = 0, of = 8;
      for (let i = od; i < of; ++i) {
        m1.blocks[i] = 9
        m2.blocks[i] = 9
      }
      bullGamma.ms1 = 10
      new AN(2, 0, 8, bullGamma).execute()
      let total = 0
      for (let i = 0; i < 12; ++i) {
        total += m1.blocks[i]*10**i
      }
      assert.equal(total, 0, "wrong result")
    });
    it('when AD = 1, should double the absolute value of M1', function () {
      let bullGamma = new BullGamma();
      let m1 = bullGamma.getMemory(1);
      let od = 0, of = 8;
      for (let i = od; i < of; ++i) {
        m1.blocks[i] = 9
      }
      new AN(1, 0, 8, bullGamma).execute()
      let total = 0
      for (let i = 0; i < 12; ++i) {
        total += m1.blocks[i]*10**i
      }
      assert.equal(total, 199999998, "wrong result")
    });
    it('when AD = 0, should add OF to M1[OD] (M1 positive)', function () {
      let bullGamma = new BullGamma();
      let m1 = bullGamma.getMemory(1);
      m1.blocks[2] = 8
      new AN(0, 2, 8, bullGamma).execute()
      assert.equal(m1.blocks[3]*10 + m1.blocks[2], 16, "wrong result")
    });
    it('when AD = 0, should add OF to M1[OD] (M1 negative)', function () {
      let bullGamma = new BullGamma();
      let m1 = bullGamma.getMemory(1);
      m1.blocks[2] = 8
      bullGamma.ms1 = 10
      new AN(0, 2, 8, bullGamma).execute()
      assert.equal(m1.blocks[2], 0, "wrong result")
    });
    it('should report carry to M1[0] in case of overflow on M1[11]', function () {
      let bullGamma = new BullGamma();
      let m1 = bullGamma.getMemory(1);
      let m2 = bullGamma.getMemory(2);
      m1.blocks[11] = 9
      m2.blocks[11] = 9
      new AN(2, 0, 12, bullGamma).execute()
      assert.equal(m1.blocks[0]*10 + m1.blocks[11], 18, "wrong result")
    });
  });
});