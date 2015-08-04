FROM nginx:1.9.2
MAINTAINER Dockito

RUN apt-get update && apt-get install -yq curl

ENV PLATFORM=linux
ENV ARCH=x64
ENV NODE_VERSION=0.12.7
ENV NODE_PATH="/usr/local/node"

RUN mkdir -p "$NODE_PATH" && \
    curl --progress-bar http://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-$PLATFORM-$ARCH.tar.gz \
    | tar xzf - --strip-components=1 -C "$NODE_PATH"

ENV PATH /usr/local/node/bin:$PATH

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

CMD [ "npm", "run", "generate-and-start-nginx" ]
