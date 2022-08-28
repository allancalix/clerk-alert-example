#!/usr/bin/env bash

set -eu

CMD="clerk --config $PWD/.clerk/clerk/clerk.toml txn sync ${@}"

litestream replicate \
  -config .clerk/clerk/litestream.yaml \
  -exec "$CMD"
