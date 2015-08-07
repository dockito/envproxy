FROM nginx:1.9.2
MAINTAINER Dockito

# Install curl
RUN apt-get update && apt-get install -yq curl

# Configure Nginx and apply fix for very long server names
RUN echo "daemon off;" >> /etc/nginx/nginx.conf \
 && sed -i 's/^http {/&\n    server_names_hash_bucket_size 128;/g' /etc/nginx/nginx.conf

# Install nodejs
ENV PLATFORM=linux
ENV ARCH=x64
ENV NODE_VERSION=0.12.7
ENV NODE_PATH="/usr/local/node"

RUN mkdir -p "$NODE_PATH" && \
    curl --progress-bar http://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-$PLATFORM-$ARCH.tar.gz \
    | tar xzf - --strip-components=1 -C "$NODE_PATH"

ENV PATH /usr/local/node/bin:$PATH

WORKDIR /usr/src/app
COPY . /usr/src/app
RUN npm install --unsafe-perm

CMD [ "npm", "run", "generate-and-start-nginx" ]
