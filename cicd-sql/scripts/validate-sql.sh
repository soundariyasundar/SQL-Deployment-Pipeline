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

# Every statement should end with ;
LAST_LINE=$(grep -v '^[[:space:]]*$' "$FILE" | tail -1)

if [[ "$LAST_LINE" != *";" ]]; then
    echo "ERROR: SQL statement must end with ';'"
    exit 1
fi

# Parentheses check
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
if grep -qiE "select|insert|update|delete|create|alter|drop" "$FILE"; then
    if grep -qE "^[[:space:]]*(select|insert|update|delete|create|alter|drop)" "$FILE"; then
        echo "WARNING: Consider using uppercase SQL keywords."
    fi
fi

echo ""
echo "SQL formatting validation completed successfully."
