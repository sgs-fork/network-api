FROM rust:1.83.0

WORKDIR /app

RUN apt-get update && \
    apt install -y build-essential pkg-config libssl-dev git-all protobuf-compiler

COPY entrypoint.sh .

RUN chmod +x entrypoint.sh

CMD ["./entrypoint.sh"]
