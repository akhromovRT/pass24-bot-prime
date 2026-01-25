#!/usr/bin/env bash
# Инициализация БД PASS24: создаёт data/ и применяет schema.sql

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DATA_DIR="${DATA_DIR:-$PROJECT_ROOT/data}"
DB_PATH="${DB_PATH:-$DATA_DIR/pass24.db}"

mkdir -p "$DATA_DIR"
sqlite3 "$DB_PATH" < "$SCRIPT_DIR/schema.sql"
sqlite3 "$DB_PATH" < "$SCRIPT_DIR/seed_categories.sql"
echo "DB initialized: $DB_PATH"
