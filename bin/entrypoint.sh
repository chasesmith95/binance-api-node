#!/bin/bash

source setup.sh
echo "Running $0 in $PWD"
set -ev
su bnbchaind -c "/usr/local/bin/bnbchaind start --home ${BNCHOME} --pruning breathe &"
sleep 1
/usr/local/bin/bnbcli api-server --chain-id 'Binance-Chain-Tigris' --node tcp://${FULL_NODE_ADDR}:27147 --laddr tcp://0.0.0.0:8080 --trust-node
