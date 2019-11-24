
ARG NODE_VERSION=0.6.3
ARG CLI_VERSION=0.6.3
ARG NODE_TYPE=fullnode
ARG NETWORK=prod
ARG FULL_NODE_ADDR=0.0.0.0
FROM ubuntu:18.04 as builder

ARG NODE_VERSION
ARG CLI_VERSION
ARG NODE_TYPE
ARG FULL_NODE_ADDR

RUN apt-get update && apt-get install -y --no-install-recommends upx ca-certificates wget git git-lfs binutils
RUN	git lfs clone https://github.com/binance-chain/node-binary.git

RUN chmod +x /node-binary/cli/testnet/${CLI_VERSION}/linux/tbnbcli \
; chmod +x /node-binary/cli/prod/${CLI_VERSION}/linux/bnbcli \
; chmod +x /node-binary/${NODE_TYPE}/testnet/${NODE_VERSION}/linux/bnbchaind \
; chmod +x /node-binary/${NODE_TYPE}/prod/${NODE_VERSION}/linux/bnbchaind

FROM ubuntu:18.04

ARG HOST_USER_UID=1000
ARG HOST_USER_GID=1000

ARG NODE_VERSION
ARG CLI_VERSION
ARG NODE_TYPE
ARG NETWORK
ARG FULL_NODE_ADDR

ENV NODE_VERSION=$NODE_VERSION
ENV CLI_VERSION=$CLI_VERSION
ENV FULL_NODE_ADDR=$FULL_NODE_ADDR
ENV NETWORK=$NETWORK

ENV BNCHOME=/opt/bnbchaind

COPY --from=builder /node-binary/cli/testnet/${CLI_VERSION}/linux/tbnbcli /node-binary/cli/testnet/${NODE_VERSION}/linux/
COPY --from=builder /node-binary/cli/prod/${CLI_VERSION}/linux/bnbcli /node-binary/cli/prod/${NODE_VERSION}/linux/
COPY --from=builder /node-binary/${NODE_TYPE}/testnet/${NODE_VERSION}/linux/bnbchaind /node-binary/fullnode/testnet/${NODE_VERSION}/linux/
COPY --from=builder /node-binary/${NODE_TYPE}/prod/${NODE_VERSION}/linux/bnbchaind /node-binary/fullnode/prod/${NODE_VERSION}/linux/
COPY --from=builder /node-binary/${NODE_TYPE}/testnet/${NODE_VERSION}/config/* /node-binary/fullnode/testnet/${NODE_VERSION}/config/
COPY --from=builder /node-binary/${NODE_TYPE}/prod/${NODE_VERSION}/config/* /node-binary/fullnode/prod/${NODE_VERSION}/config/
COPY ./bin/*.sh /usr/local/bin/


RUN set -ex \
&& chmod +x /usr/local/bin/*.sh \
&& mkdir -p "$BNCHOME" \
&& groupadd --gid "$HOST_USER_GID" bnbchaind \
&& useradd --uid "$HOST_USER_UID" --gid "$HOST_USER_GID" --shell /bin/bash --no-create-home bnbchaind \
&& chown -R bnbchaind:bnbchaind "$BNCHOME"

VOLUME ${BNCHOME}

EXPOSE 27146 27147 8080

ENTRYPOINT ["entrypoint.sh"]
