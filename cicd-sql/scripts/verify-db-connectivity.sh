#!/bin/bash

set -e

echo "Checking database connectivity..."

mysql \
-h "$DB_HOST" \
-P "$DB_PORT" \
-u "$DB_USER" \
-p"$DB_PASSWORD" \
-e "SELECT 1;" > /dev/null

echo "Database Connectivity Successful"
