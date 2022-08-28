#!/usr/bin/env bash

set -eu

QUERY="select json_extract(source, '$.amount') as amount, json_extract(source, '$.name') as name from transactions WHERE amount > 5.00 AND name LIKE 'Uber%';"

if [[ ! -z $(sqlite3 .clerk/data/clerk.db "$QUERY") ]]; then
  echo "I got paid, send myself an email or something!"
fi
