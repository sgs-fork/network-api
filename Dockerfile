FROM rust:1.83.0

WORKDIR /app

RUN dpkg --add-architecture arm64 &&  \
    apt-get update && \
     apt-get install -y --no-install-recommends \
        build-essential pkg-config git-all protobuf-compiler \
        gcc-aarch64-linux-gnu g++-aarch64-linux-gnu \
        libssl-dev && \
    git clone https://github.com/sgs-fork/network-api.git . && \
    rm -rf /var/lib/apt/lists/*

RUN rustup target add x86_64-unknown-linux-gnu aarch64-unknown-linux-gnu

WORKDIR /app/clients/cli

RUN cargo build --release --bin prover --target x86_64-unknown-linux-gnu && \
    cargo build --release --bin prover --target aarch64-unknown-linux-gnu

COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

CMD ["/app/entrypoint.sh"]
