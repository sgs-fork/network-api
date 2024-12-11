FROM rust:1.83.0-alpine3.21

WORKDIR /app

RUN apk update && \
    apk add --no-cache git musl-dev build-base openssl openssl-dev pkgconfig protobuf protobuf-dev && \
    git clone https://github.com/sgs-fork/network-api.git . && \
    cd clients/cli && \
    cargo build --release --bin prover

CMD ["cargo", "run", "--release", "--bin", "prover", "--", "beta.orchestrator.nexus.xyz"]
