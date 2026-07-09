#!/bin/bash

FILE=$1

echo "Validating SQL..."

if [ ! -f "$FILE" ]
then
    echo "SQL File Not Found"
    exit 1
fi

if grep -qiE "DROP|TRUNCATE|ALTER|GRANT|REVOKE" "$FILE"
then
    echo "Dangerous SQL Command Found"
    exit 1
fi

if grep -qi "^UPDATE" "$FILE"
then
    grep -qi "WHERE" "$FILE" || {
        echo "UPDATE without WHERE clause"
        exit 1
    }
fi

if grep -qi "^DELETE" "$FILE"
then
    grep -qi "WHERE" "$FILE" || {
        echo "DELETE without WHERE clause"
        exit 1
    }
fi

echo "Validation Successful"
