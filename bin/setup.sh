
#!/bin/bash

if [ ! -d "${BNCHOME}/config/" ]; then
mkdir -p ${BNCHOME}/config/
cp /node-binary/fullnode/${NETWORK}/${NODE_VERSION}/config/* ${BNCHOME}/config/
chown -R bnbchaind:bnbchaind ${BNCHOME}/config/
fi

cp /node-binary/fullnode/${NETWORK}/${NODE_VERSION}/linux/bnbchaind /usr/local/bin/
chmod +x /usr/local/bin/bnbchaind

if [ ${NETWORK} == "testnet" ]; then
    ln -sv /node-binary/cli/${NETWORK}/${CLI_VERSION}/linux/tbnbcli /usr/local/bin/tbnbcli
    chmod +x /usr/local/bin/tbnbcli
    echo 'defaultpassphrase' | /usr/local/bin/tbnbcli keys add test_key
else
    ln -sv /node-binary/cli/${NETWORK}/${CLI_VERSION}/linux/bnbcli /usr/local/bin/bnbcli
    chmod +x /usr/local/bin/bnbcli
    echo 'defaultpassphrase' | /usr/local/bin/bnbcli keys add test_key
fi

# Turn on console logging

sed -i 's/logToConsole = false/logToConsole = true/g' ${BNCHOME}/config/app.toml
