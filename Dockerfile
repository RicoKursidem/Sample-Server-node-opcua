FROM node:21.4.0-alpine3.17

COPY ca-certificates-20230506-r0.apk /ca-certificates-20230506-r0.apk
RUN apk add /ca-certificates-20230506-r0.apk
RUN rm /ca-certificates-20230506-r0.apk

COPY DEOSB-Sophos-TransparentProxy.crt /usr/local/share/ca-certificates/
RUN update-ca-certificates

WORKDIR /home/node/opcua-server

# hadolint ignore=DL3018
RUN apk --no-cache add \
     openssl=3.0.12-r4 \
     python3=3.10.13-r0 \
     make=4.3-r1 \
     g++=12.2.1_git20220924-r4 \
     gcc=12.2.1_git20220924-r4
     
COPY . /home/node/opcua-server

# RUN npm config set strict-ssl false
# RUN npm config set registry "http://registry.npmjs.org/"
RUN npm install

EXPOSE 4840

RUN chown -R node:node /home/node/opcua-server

USER node

ENTRYPOINT ["npm", "run", "start"]
