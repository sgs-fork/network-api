#!/usr/bin/env bash

git clone https://github.com/sgs-fork/network-api.git .

cd clients/cli || exit
cargo run --release --bin prover -- beta.orchestrator.nexus.xyz