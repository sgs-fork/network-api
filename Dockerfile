FROM rust:1.83.0

RUN apt-get update && \
    apt-get install -y \
        openssl \
        libssl-dev && \
    rm -rf /var/lib/apt/lists/*

COPY ./clients/cli/x86_64-unknown-linux-gnu/release/prover /usr/local/bin/prover-linux
COPY ./clients/cli/aarch64-apple-darwin/release/prover /usr/local/bin/prover-apple

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

CMD ["/usr/local/bin/entrypoint.sh"]
