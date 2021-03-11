FROM node:carbon-alpine as builder
LABEL maintainer="Bart Van Bos <bartvanbos@gmail.com>"
RUN apk add -U --no-cache build-base python git
WORKDIR /wetty-app
RUN git clone https://github.com/butlerx/wetty /wetty-app && \
	  git checkout d0aaa35dbfcb30d8739c22cb3226238ad23a6d7d && \
    yarn && \
    yarn build && \
    yarn install --production --ignore-scripts --prefer-offline


FROM node:carbon-alpine
LABEL maintainer="Bart Van Bos <bartvanbos@gmail.com>"
ENV NODE_ENV=production
ARG DEBUG_TOOLS
ARG DEBUG_TOOL_LIST

COPY --from=builder /wetty-app/dist /wetty-app/dist
COPY --from=builder /wetty-app/node_modules /wetty-app/node_modules
COPY --from=builder /wetty-app/package.json /wetty-app/package.json
COPY --from=builder /wetty-app/index.js /wetty-app/index.js
RUN apk add -U --no-cache dumb-init openssh-client sshpass curl netcat-openbsd jq gcc libc-dev python3 python3-dev py3-pip && \
    pip3 install python-bsonjs && \
    if [ "$DEBUG_TOOLS" = "true" ] ; then apk add -U --no-cache ${DEBUG_TOOL_LIST} ; fi && \
    adduser -D -h /home/admin -s /bin/sh admin && ( echo "admin:admin" | chpasswd ) && adduser admin root

ADD run.sh /
ADD ./bson-decode/bson-decode.py  /usr/local/bin/bson_decode

# Wetty ENV params
ENV REMOTE_SSH_SERVER=0.0.0.0 \
    REMOTE_SSH_PORT=22 \
    WETTY_PORT=3000 

EXPOSE 3000

WORKDIR /
ENTRYPOINT "./run.sh"
