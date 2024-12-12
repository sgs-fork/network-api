FROM debian:bullseye-slim

COPY ./clients/cli/x86_64-unknown-linux-gnu/release/prover /usr/local/bin/prover-linux
COPY ./clients/cli/aarch64-apple-darwin/release/prover /usr/local/bin/prover-apple

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

CMD ["/usr/local/bin/entrypoint.sh"]
