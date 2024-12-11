FROM rust:1.83.0

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential pkg-config libssl-dev git-all protobuf-compiler && \
    git clone https://github.com/sgs-fork/network-api.git . && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app/clients/cli
RUN cargo build --release --bin prover

CMD ["cargo", "run", "--release", "--bin", "prover", "--", "beta.orchestrator.nexus.xyz"]