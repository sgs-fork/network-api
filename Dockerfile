FROM rust:1.83.0

RUN dpkg --add-architecture arm64 && \
    apt-get update && \
    apt-get install -y \
        build-essential \
        pkg-config \
        git-all \
        protobuf-compiler \
        gcc-x86-64-linux-gnu \
        g++-x86-64-linux-gnu \
        gcc-aarch64-linux-gnu \
        g++-aarch64-linux-gnu \
        libssl-dev \
        libssl-dev:amd64 && \
    rm -rf /var/lib/apt/lists/*

COPY ./clients/cli/x86_64-unknown-linux-gnu/release/prover /usr/local/bin/prover-linux
COPY ./clients/cli/aarch64-apple-darwin/release/prover /usr/local/bin/prover-apple

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

CMD ["/usr/local/bin/entrypoint.sh"]
