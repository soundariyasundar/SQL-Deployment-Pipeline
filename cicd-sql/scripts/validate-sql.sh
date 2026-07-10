#!/bin/bash
set -e

FILE=$1

echo "======================================"
echo "SQL Validation Started"
echo "======================================"

# File exists
if [ ! -f "$FILE" ]; then
    echo "ERROR: SQL file not found."
    exit 1
fi

# File not empty
if [ ! -s "$FILE" ]; then
    echo "ERROR: SQL file is empty."
    exit 1
fi

# SQL must end with ;
LAST_LINE=$(grep -v '^[[:space:]]*$' "$FILE" | tail -1)

if [[ "$LAST_LINE" != *";" ]]; then
    echo "ERROR: SQL statement must end with ';'"
    exit 1
fi

# Detect ':' instead of ';'
if grep -q ":$" "$FILE"; then
    echo "ERROR: Invalid ':' found. SQL statements must end with ';'"
    exit 1
fi

# Parentheses validation
OPEN=$(grep -o "(" "$FILE" | wc -l)
CLOSE=$(grep -o ")" "$FILE" | wc -l)

if [ "$OPEN" -ne "$CLOSE" ]; then
    echo "ERROR: Unbalanced parentheses."
    exit 1
fi

# Warn if tabs are used
if grep -q $'\t' "$FILE"; then
    echo "WARNING: Tabs detected. Use spaces for indentation."
fi

# Warn if trailing spaces exist
if grep -nE "[[:blank:]]+$" "$FILE"; then
    echo "WARNING: Trailing spaces found."
fi

# Warn if SQL keywords are lowercase
if grep -qE "^[[:space:]]*(select|insert|update|delete|create|alter|drop|truncate|grant|revoke)" "$FILE"; then
    echo "WARNING: SQL keywords should preferably be uppercase."
fi

echo ""
echo "======================================"
echo "SQL Validation Successful"
echo "======================================"
