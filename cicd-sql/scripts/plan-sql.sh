#!/bin/bash

FILE=$1

echo "===================================="
echo " SQL Execution Plan"
echo "===================================="

cat "$FILE"

echo ""

if grep -qi "^UPDATE" "$FILE"
then

TABLE=$(grep -i "^UPDATE" "$FILE" | awk '{print $2}')

WHERE=$(grep -i "WHERE" "$FILE")

COUNT=$(mysql \
-h "$DB_HOST" \
-P "$DB_PORT" \
-u "$DB_USER" \
-p"$DB_PASSWORD" \
-D "$DB_NAME" \
-e "SELECT COUNT(*) FROM ${TABLE} ${WHERE};" \
-s -N)

echo ""
echo "Table : $TABLE"
echo "Rows to Update : $COUNT"

fi
