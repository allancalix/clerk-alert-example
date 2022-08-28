# clerk-alert-example
A template repository for demonstrating how you could use clerk, litestream,
and Plaid for building an ad-hoc personal transaction monitoring system. In this
example, we print a message when we encounter a paycheck transaction.

Litestream is used here to replicate transaction data to S3 so data could be
accessed seamlessly across a variety of machines. This means you could perform
transaction syncs manually and have "read-replica" like cron jobs that check data
periodically.

## Requirements
- [clerk](https://github.com/allancalix/clerk) cli
- [litestream](https://litestream.io/install/) cli
- [tera-cli](https://github.com/chevdor/tera-cli) - jinja2-like templating
- [shadowenv](https://github.com/Shopify/shadowenv) - automatic directory-based environment variables for secrets
- sqlite3 - probably already installed
- Plaid API key - require development level access for real transaction data
- S3 credentials - used to synchronize transaction data between machines

You can update the [env.sh](./env.sh) file with your secret credentials, this is
used to automatically configure litestream and clerk. After the `.shadowenv`
directory is created (on first link) these secrets are no longer required in this script.
## Use
```bash
# Bootstrap your first Plaid link
source env.sh
# Repeat for as many accounts as you'd like to link.
make link
```

Some useful commands to get you started. Check paycheck is a bit naive, in a real
implementation you'd probably want to keep a watermark saved in the repository that
says you've already checked transactions up to the watermark to avoid duplicate
alerts. You could use the date of transactions but the transaction `id` column is
ULID and can be used as a cursor as well.
```bash
# Sync transactions starting from the given date.
./scripts/sync.sh --begin 2022-08-14

./scripts/check-paycheck.sh
```

### Paycheck alert
A quick breakdown of the query used to select the paycheck transaction from the
datastore.

```sql
select
  -- Clerk stores the raw data returned from Plaid's API as json in the database.
  -- We can use this to access the raw payloads while clerk handles syncing and
  -- link management.
  json_extract(source, '$.amount') as amount,
  json_extract(source, '$.name') as name
FROM transactions
-- You'll likely want to set a floor amount and set name equal to those that appear
-- in your transactions.
WHERE amount > 5.00 AND name LIKE 'Uber%';
```
