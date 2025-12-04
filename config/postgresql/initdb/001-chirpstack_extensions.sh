#!/bin/bash
set -e

echo "======================================================"
echo "======================================================"
echo "Initializing ChirpStack PostgreSQL extensions..."
echo "======================================================"
echo "======================================================"



psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname="$POSTGRES_DB" <<-EOSQL
    create extension if not exists pg_trgm;
    create extension if not exists hstore;    
EOSQL