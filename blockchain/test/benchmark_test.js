/* global assert:true, artifacts:true, contract:true */
/* eslint-env mocha */

var Benchmark = artifacts.require('Benchmark');

contract('Benchmark', function() {
  let benchmark;

  before('deploy benchmark', done => {
    Benchmark.new().then(instance => {
      benchmark = instance;
      done();
    });
  });

  it('should have all getters with correct value', async () => {
    // eslint-disable-next-line babel/new-cap
    var watcher = benchmark.FinishWrite();

    await benchmark.writeData(1, 'testData');
    let events = await watcher.get();
    console.log(events);
    assert.equal(events.length, 1);
    assert.equal(events[0].args.data.valueOf(), 'testData');
  });

  it('should have all getters with correct value', async () => {
    // eslint-disable-next-line babel/new-cap
    var watcher = benchmark.FinishWriteWithoutHash();

    const crypto = require('crypto');
    const hash1 = crypto.createHash('sha256');
    hash1.update('testData1');
    let sha1 = hash1.digest('hex');

    const hash2 = crypto.createHash('sha256');
    hash2.update('testData2');
    let sha2 = hash2.digest('hex');

    const hash3 = crypto.createHash('sha256');
    hash3.update('testData3');
    let sha3 = hash3.digest('hex');

    await benchmark.writeDataWithoutHash(1, 'testData', sha1, sha2, sha3);
    let events = await watcher.get();
    console.log(events);
    assert.equal(events.length, 1);
    assert.equal(events[0].args.data.valueOf(), 'testData');
  });
});
