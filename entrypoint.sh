#!/usr/bin/env bash

set -e

if [ "$(uname -m)" = "x86_64" ]; then
    echo "正在运行 x86_64 二进制文件..."
    exec /app/clients/cli/target/x86_64-unknown-linux-gnu/release/prover -- beta.orchestrator.nexus.xyz
elif [ "$(uname -m)" = "aarch64" ]; then
    echo "正在运行 aarch64 二进制文件..."
    exec /app/clients/cli/target/aarch64-unknown-linux-gnu/release/prover -- beta.orchestrator.nexus.xyz
else
    echo "不支持的架构: $(uname -m)"
    exit 1
fi
