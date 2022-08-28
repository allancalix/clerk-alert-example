#!/usr/bin/env bash

set -eu

litestream replicate \
  -config .clerk/clerk/litestream.yaml \
  -exec "clerk --config $PWD/.clerk/clerk/clerk.toml link"
