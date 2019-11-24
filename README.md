# Binance API Server

This is a containerized version of the Binance API Server. It is meant to be used for query services only, and generates a new local key to be established on the network.

- Binance Chain API Server
`8080:{your exposed port}`

- Binance Chain Node
`27147:{your exposed port}`


### Getting started

##### Arguments

`NETWORK=prod`

`CLI_VERSION=0.6.3`

`NODE_VERSION=0.6.3`

`FULL_NODE_ADDR=0.0.0.0`

#### Pull from Docker
```
docker pull chasesmith95/binance-api-node:latest
```

#### Run container

```
docker run -d -v /opt/binance-data:/opt/bnbchaind -p 27146:27146 -p 27147:27147 -p 8080:8080 --restart unless-stopped --ulimit nofile=16000:16000 chasesmith95/binance-api-node:latest
```

- Binance Chain API Server
`8080`

- Binance Chain Node
`27147`


##### Volumes

`"/tmp/opt/binance-data:/opt/bnbchaind"`
