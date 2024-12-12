#!/usr/bin/env bash

ARCH=$(uname -m)

echo "Current architecture: $ARCH"

if [ "$ARCH" == "x86_64" ]; then
  exec /usr/local/bin/prover-linux -- beta.orchestrator.nexus.xyz
elif [ "$ARCH" == "aarch64" ]; then
  exec /usr/local/bin/prover-apple -- beta.orchestrator.nexus.xyz
else
  echo "Unsupported architecture: $ARCH"
  exit 1
fi
