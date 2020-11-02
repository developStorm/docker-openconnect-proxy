FROM alpine:3.12 AS builder
RUN apk add --update --no-cache \
      --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
      bash \
      curl \
      git  \
      make \
      build-base
      
RUN mkdir /build \
      && cd /build \
      && git clone https://github.com/rofl0r/microsocks.git \
      && cd microsocks \
      && make \
      && make install \
      && rm -R /build

FROM alpine:3.12
WORKDIR /proxy

COPY --from=builder /usr/local/bin/microsocks /usr/local/bin

RUN echo 'http://dl-cdn.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories \
      && apk add --update --no-cache \
      dumb-init \
      openconnect

ADD entrypoint.sh .

ENTRYPOINT [  "dumb-init", "/proxy/entrypoint.sh" ]
