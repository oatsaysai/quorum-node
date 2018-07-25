#!/bin/bash
set -u
set -e

wait_peer_count() {
  while true; do 
    echo "Check peer_count"
    PEER_COUNT="$(curl -s $SEED_HOSTNAME:22000 -X POST --data '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}' | jq -r .result)"
    [ "$(PEER_COUNT=$PEER_COUNT python wait_peer_count.py)" = "false" ] || break
    sleep 5
  done
}

if [ $NODE != "" ]; then

  if [ $NODE == "1" ]; then
    echo "[*] Cleaning up temporary data directories"
    rm -rf qdata
    mkdir -p qdata/logs
  fi

  sleep 5
  mkdir -p qdata/dd$NODE/{keystore,geth}
  i=$NODE
  DDIR="qdata/c$i"
  mkdir -p $DDIR
  echo | constellation-node --generatekeys=$DDIR/tm
  echo
  cp "config/tm.conf" "$DDIR/tm.conf"
  sed -i -e "s%qdata/c%qdata/c$i%g" $DDIR/tm.conf

  if [ $NODE == "1" ]; then
    echo "[*] Configuring node $NODE"
    
    bootnode -genkey qdata/dd$NODE/geth/nodekey
    geth --datadir qdata/dd$NODE init genesis.json
    geth --datadir qdata/dd$NODE account new --password passwords.txt
    
    nohup constellation-node $DDIR/tm.conf &> qdata/logs/constellation$i.log &
    
    IP="$(ip route get 8.8.8.8 | awk '{print $NF; exit}')"
    BOOTNODE_ENODE="$(bootnode -nodekey qdata/dd$NODE/geth/nodekey -writeaddress)"
    ENODE_FILE='["enode://'$BOOTNODE_ENODE'@'$IP':21000?discport=0&raftport=54000"]'
    jq -n $ENODE_FILE > qdata/dd$NODE/static-nodes.json

    sleep 10
    echo "[*] Starting Quorum node"
    set -v
    ARGS="--nodiscover --raft --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,raft --emitcheckpoints"
    PRIVATE_CONFIG=$DDIR/tm.conf geth --datadir qdata/dd$NODE $ARGS --raftport 54000 --rpcport 22000 --port 21000 --unlock 0 --password passwords.txt
  else
    echo "[*] Configuring node $NODE"
    nohup constellation-node $DDIR/tm.conf --othernodes=https://$SEED_HOSTNAME:9000/ &> qdata/logs/constellation$i.log &

    until wait_peer_count; do sleep 5; done
    sleep 2
    IP="$(ip route get 8.8.8.8 | awk '{print $NF; exit}')"
    bootnode -genkey qdata/dd$NODE/geth/nodekey
    ENODE_ID="$(bootnode -nodekey qdata/dd$NODE/geth/nodekey -writeaddress)"
    RESULT="$(echo "raft.addPeer('enode://$ENODE_ID@$IP:21000?discport=0&raftport=54000')" | geth attach http://$SEED_HOSTNAME:22000))"
    
    RAFT_ID="$(echo $RESULT | awk {'print $34'})"
    RAFT_ID=$NODE

    geth --datadir qdata/dd$NODE init genesis.json
    geth --datadir qdata/dd$NODE account new --password passwords.txt

    echo "[*] Starting Quorum node"
    set -v
    ARGS="--nodiscover --raft --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,raft --emitcheckpoints"
    PRIVATE_CONFIG=$DDIR/tm.conf geth --datadir qdata/dd$NODE $ARGS --raftjoinexisting $RAFT_ID --raftport 54000 --rpcport 22000 --port 21000 --unlock 0 --password passwords.txt
  fi
else
  echo "Please input NODE environment"
fi

