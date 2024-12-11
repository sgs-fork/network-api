FROM rust:1.83.0

WORKDIR /app

ENV AARCH64_UNKNOWN_LINUX_GNU_OPENSSL_LIB_DIR=/usr/lib/aarch64-linux-gnu
ENV AARCH64_UNKNOWN_LINUX_GNU_OPENSSL_INCLUDE_DIR=/usr/include/aarch64-linux-gnu/openssl
ENV X86_64_UNKNOWN_LINUX_GNU_OPENSSL_LIB_DIR=/usr/lib/x86_64-linux-gnu
ENV X86_64_UNKNOWN_LINUX_GNU_OPENSSL_INCLUDE_DIR=/usr/include/x86_64-linux-gnu
ENV PKG_CONFIG_ALLOW_CROSS=1
ENV PKG_CONFIG_PATH=/usr/lib/aarch64-linux-gnu/pkgconfig:/usr/lib/x86_64-linux-gnu/pkgconfig

RUN dpkg --add-architecture arm64 &&  \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential pkg-config git-all protobuf-compiler \
        gcc-aarch64-linux-gnu g++-aarch64-linux-gnu \
        libc6-dev-arm64-cross qemu qemu-user-static binfmt-support \
        openssl libssl-dev libssl-dev:arm64 && \
    update-binfmts --enable qemu-aarch64 && \
    rm -rf /var/lib/apt/lists/* && \
    rustup target add x86_64-unknown-linux-gnu aarch64-unknown-linux-gnu && \
    git clone https://github.com/sgs-fork/network-api.git .

WORKDIR /app/clients/cli

RUN cargo build --release --bin prover --target x86_64-unknown-linux-gnu && \
    cargo build --release --bin prover --target aarch64-unknown-linux-gnu

CMD ["cargo", "run", "--release", "--bin", "prover", "--", "beta.orchestrator.nexus.xyz"]
#COPY entrypoint.sh /app/entrypoint.sh
#RUN chmod +x /app/entrypoint.sh

#CMD ["/app/entrypoint.sh"]
