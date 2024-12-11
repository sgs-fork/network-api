FROM rust:1.83.0-alpine3.21

WORKDIR /app

RUN apk update && \
    apk add --no-cache \
        git musl-dev build-base openssl openssl-dev pkgconfig \
        protobuf protobuf-dev && \
    git clone https://github.com/sgs-fork/network-api.git . && \
    cd clients/cli && \
    cargo build --release --bin prover

# 设置 OpenSSL 环境变量
ENV OPENSSL_STATIC=1
ENV OPENSSL_LIB_DIR=/usr/lib
ENV OPENSSL_INCLUDE_DIR=/usr/include

CMD ["cargo", "run", "--release", "--bin", "prover", "--", "beta.orchestrator.nexus.xyz"]