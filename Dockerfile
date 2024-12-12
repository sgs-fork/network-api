FROM rust:1.83 AS builder
WORKDIR /app

RUN apt-get update && \
    apt-get install -y \
            build-essential \
            pkg-config \
            git-all \
            protobuf-compiler \
            libssl-dev \
            clang \
            gcc-x86-64-linux-gnu \
            gcc-aarch64-linux-gnu \
            g++-x86-64-linux-gnu \
            g++-aarch64-linux-gnu \
            && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/sgs-fork/network-api.git .

RUN rustup target add x86_64-unknown-linux-gnu \
                     aarch64-unknown-linux-gnu \
                     x86_64-apple-darwin \
                     aarch64-apple-darwin

WORKDIR /app/clients/cli

RUN cargo build --release --bin prover --target x86_64-unknown-linux-gnu && \
    cargo build --release --bin prover --target aarch64-unknown-linux-gnu && \
    cargo build --release --bin prover --target x86_64-apple-darwin && \
    cargo build --release --bin prover --target aarch64-apple-darwin

FROM debian:bullseye

WORKDIR /app

COPY --from=builder /app/clients/cli/target/x86_64-unknown-linux-gnu/release/prover /app/prover-linux-amd64
COPY --from=builder /app/clients/cli/target/aarch64-unknown-linux-gnu/release/prover /app/prover-linux-arm64
COPY --from=builder /app/clients/cli/target/x86_64-apple-darwin/release/prover /app/prover-darwin-amd64
COPY --from=builder /app/clients/cli/target/aarch64-apple-darwin/release/prover /app/prover-darwin-arm64

CMD ["sh", "-c", "if [ $(uname -m) = 'x86_64' ]; then if [ $(uname) = 'Darwin' ]; then exec /app/prover-darwin-amd64; else exec /app/prover-linux-amd64; fi; elif [ $(uname -m) = 'aarch64' ]; then if [ $(uname) = 'Darwin' ]; then exec /app/prover-darwin-arm64; else exec /app/prover-linux-arm64; fi; fi"]

