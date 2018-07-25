/* global artifacts:true */

var Benchmark = artifacts.require('Benchmark');

var fs = require('fs');
var objJSON = {};

const path = require('path');
// const homedir = require('os').homedir();
let addresssFilePath = path.join('/node', '/contract_addresses.json');

module.exports = function(deployer) {
  // --- Deploy public smart contract ---
  deployer.deploy(Benchmark).then(() => {
    objJSON[Benchmark.contractName] = Benchmark.address;
  });

  // --- Deploy private smart contract ---
  // deployer
  //   .deploy(Benchmark, {
  //     privateFor: [
  //       'oNspPPgszVUFw0qmGFfWwh1uxVUXgvBxleXORHj07g8=',
  //       'R56gy4dn24YOjwyesTczYa8m5xhP6hF2uTMCju/1xkY=',
  //       'UfNSeSGySeKg11DVNEnqrUtxYRVor4+CvluI8tVv62Y='
  //     ]
  //   })
  //   .then(() => {
  //     objJSON[Benchmark.contractName] = Benchmark.address;
  //   });
  deployer.then(() => {
    fs.writeFile(
      addresssFilePath,
      JSON.stringify(objJSON, null, 2),
      err => {
        if (err) throw err;
      }
    );
  });
};
