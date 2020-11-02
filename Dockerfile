FROM alpine:3.12 as builder
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
COPY --from builder /usr/local/bin/microsocks /usr/local/bin

RUN apk add --update --no-cache \
      --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
      dumb-init \
      openconnect

ADD ./scripts ./scripts
RUN chmod 755 ./scripts/*

ENTRYPOINT [  "dumb-init", "./scripts/entrypoint.sh" ]
