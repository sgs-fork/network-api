FROM rust:1.83.0 AS builder-amd64
ARG TARGETARCH=amd64

WORKDIR /app
RUN apt-get update && \
    apt-get install -y \
            build-essential  \
            pkg-config  \
            git-all  \
            protobuf-compiler \
            libssl-dev  \
            gcc && \
    rm -rf /var/lib/apt/lists/* && \
    git clone https://github.com/sgs-fork/network-api.git .

ENV X86_64_UNKNOWN_LINUX_GNU_OPENSSL_LIB_DIR=/usr/lib/x86_64-linux-gnu
ENV X86_64_UNKNOWN_LINUX_GNU_OPENSSL_INCLUDE_DIR=/usr/include/x86_64-linux-gnu/openssl

WORKDIR /app/clients/cli
RUN rustup target add x86_64-unknown-linux-gnu && \
    cargo build --release --bin prover --target x86_64-unknown-linux-gnu

FROM rust:1.83.0 AS builder-arm64
ARG TARGETARCH=arm64

WORKDIR /app

RUN dpkg --add-architecture arm64 &&  \
    apt-get update && \
    apt-get install -y \
            build-essential  \
            pkg-config git-all  \
            protobuf-compiler \
            gcc-aarch64-linux-gnu g++-aarch64-linux-gnu \
            libssl-dev:arm64 && \
    rm -rf /var/lib/apt/lists/* && \
    git clone https://github.com/sgs-fork/network-api.git .

ENV AARCH64_UNKNOWN_LINUX_GNU_OPENSSL_LIB_DIR=/usr/lib/aarch64-linux-gnu
ENV AARCH64_UNKNOWN_LINUX_GNU_OPENSSL_INCLUDE_DIR=/usr/include/aarch64-linux-gnu/openssl

WORKDIR /app/clients/cli
RUN rustup target add aarch64-unknown-linux-gnu && \
    cargo build --release --bin prover --target aarch64-unknown-linux-gnu

FROM debian:bullseye-slim

WORKDIR /app

COPY --from=builder-amd64 /app/clients/cli/target/x86_64-unknown-linux-gnu/release/prover /app/prover-amd64
COPY --from=builder-arm64 /app/clients/cli/target/aarch64-unknown-linux-gnu/release/prover /app/prover-arm64

CMD ["sh", "-c", "if [ $(uname -m) = 'x86_64' ]; then exec /app/prover-amd64; else exec /app/prover-arm64; fi -- beta.orchestrator.nexus.xyz"]
