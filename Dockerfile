FROM rust:1.83.0-alpine3.21

WORKDIR /app

COPY enterpoint.sh .

RUN chmod +x enterpoint.sh

ENTRYPOINT ["./enterpoint.sh"]