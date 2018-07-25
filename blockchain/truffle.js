require('babel-register');

module.exports = {
  networks: {
    development: {
      host: process.env.SEED_HOSTNAME || '127.0.0.1',
      port: 22000, // was 8545
      network_id: '*', // Match any network id
      gasPrice: 0,
      gas: 4500000
    }
  }
};
