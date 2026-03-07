#!/bin/bash
# Run SQL against your remote Supabase database
# Usage:
#   ./supabase/run-sql.sh "SELECT * FROM \"User_Tbl\" LIMIT 5;"
#   ./supabase/run-sql.sh path/to/file.sql

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Load token from .env.supabase
if [ -f "$PROJECT_DIR/.env.supabase" ]; then
  source "$PROJECT_DIR/.env.supabase"
fi

PROJECT_REF="${SUPABASE_PROJECT_REF:-vreuvpzxnvrhftafmado}"

if [ -z "$SUPABASE_ACCESS_TOKEN" ]; then
  echo "Error: No access token found. Create .env.supabase with SUPABASE_ACCESS_TOKEN=your_token"
  exit 1
fi

# If argument is a file, read its contents; otherwise treat as SQL string
if [ -f "$1" ]; then
  SQL=$(cat "$1")
  echo "Running: $1"
else
  SQL="$1"
fi

if [ -z "$SQL" ]; then
  echo "Usage: ./supabase/run-sql.sh \"SQL query\" or ./supabase/run-sql.sh file.sql"
  exit 1
fi

# Escape SQL for JSON (handle backslashes, quotes, newlines, tabs)
ESCAPED_SQL=$(printf '%s' "$SQL" | sed 's/\\/\\\\/g; s/"/\\"/g; s/\t/\\t/g' | tr '\n' ' ')

RESPONSE=$(curl -s -X POST \
  "https://api.supabase.com/v1/projects/${PROJECT_REF}/database/query" \
  -H "Authorization: Bearer ${SUPABASE_ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{\"query\": \"${ESCAPED_SQL}\"}")

echo "$RESPONSE"
