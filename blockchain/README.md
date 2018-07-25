Preparation
  ```sh
  npm install
  npm install -g truffle
  npm install -g ganache-cli
  truffle compile
  ```

Start ganache-cli with option unlock
  ```sh
  ganache-cli --unlock 0,1,2,3,4 --port 22000 
  truffle migrate
  ```

Test smart contract
  ```sh
  truffle test
  ```