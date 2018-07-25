#!/bin/bash
set -u
set -e

wait_peer_count() {
  while true; do 
    echo "Check peer_count"
    PEER_COUNT="$(curl -s $SEED_HOSTNAME:22000 -X POST --data '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}' | jq -r .result)"
    [ "$(PEER_COUNT=$PEER_COUNT NODE=$MIN_NODE python wait_peer_count.py)" = "false" ] || break
    sleep 5
  done
}

wait_address_file() {
   while true; do 
    echo "Check address file"
    if [ -e /node/contract_addresses.json ]
    then
      break
    fi
    sleep 5
  done
}

if [ $NODE == "1" ]; then
  if [ -e /node/contract_addresses.json ]
  then
    rm /node/contract_addresses.json
  fi
  until wait_peer_count; do sleep 5; done
  echo "Deploy smart contract"
  cd /blockchain && truffle migrate
  echo "Done"
  cd /api && npm run api -- --node $NODE
else
  sleep 5
  until wait_address_file; do sleep 5; done
  echo "Compile smart contract"
  cd /blockchain && truffle compile
  echo "Done"
  cd /api && npm run api -- --node $NODE
fi

