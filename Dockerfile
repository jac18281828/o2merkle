FROM ghcr.io/xmtp/foundry:latest

ARG PROJECT=o2merkle
WORKDIR /workspaces/${PROJECT}
RUN chown -R xmtp:xmtp .
COPY --chown=xmtp:xmtp . .
ENV USER=xmtp
USER xmtp
ENV PATH=${PATH}:~/.cargo/bin
RUN yarn install --frozen-lockfile
RUN yarn prettier:check
RUN yarn lint
RUN forge test -vvv
