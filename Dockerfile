FROM alpine:edge AS builder
RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing git make cmake libstdc++ gcc g++ libuv-dev openssl-dev hwloc-dev automake libtool autoconf linux-headers && \
	git clone https://github.com/xmrig/xmrig && \
	mkdir xmrig/build && cd xmrig/build && \
    cmake .. && \
	make -j$(nproc)

FROM alpine:edge  
RUN apk --no-cache add hwloc-dev libuv-dev
WORKDIR /root/
COPY config.json .
COPY --from=builder /xmrig/build/xmrig .
ENTRYPOINT ["./xmrig", "--config", "/root/config.json"]
