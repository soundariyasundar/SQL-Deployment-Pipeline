#!/bin/bash
set -e

FILE=$1

echo "=============================================="
echo "         SQL EXECUTION PLAN"
echo "=============================================="
echo ""

echo "SQL Script:"
cat "$FILE"
echo ""
echo "----------------------------------------------"

TYPE=$(grep -iE "^(SELECT|UPDATE|DELETE|INSERT|CREATE|ALTER|DROP)" "$FILE" | head -1 | awk '{print toupper($1)}')

case "$TYPE" in

SELECT)

echo ""
echo "Intended Output:"
echo "----------------------------------------------"

mysql \
-h "$DB_HOST" \
-P "$DB_PORT" \
-u "$DB_USER" \
-p"$DB_PASSWORD" \
"$DB_NAME" < "$FILE"

;;

UPDATE)

TABLE=$(grep -i "^UPDATE" "$FILE" | awk '{print $2}')
WHERE=$(grep -i "WHERE" "$FILE")

echo ""
echo "Rows that will be updated:"
echo "----------------------------------------------"

mysql \
-h "$DB_HOST" \
-P "$DB_PORT" \
-u "$DB_USER" \
-p"$DB_PASSWORD" \
-D "$DB_NAME" \
-e "SELECT * FROM ${TABLE} ${WHERE};"

COUNT=$(mysql \
-h "$DB_HOST" \
-P "$DB_PORT" \
-u "$DB_USER" \
-p"$DB_PASSWORD" \
-D "$DB_NAME" \
-e "SELECT COUNT(*) FROM ${TABLE} ${WHERE};" \
-s -N)

echo ""
echo "Total Rows to Update : $COUNT"

;;

DELETE)

TABLE=$(grep -i "^DELETE FROM" "$FILE" | awk '{print $3}')
WHERE=$(grep -i "WHERE" "$FILE")

echo ""
echo "Rows that will be deleted:"
echo "----------------------------------------------"

mysql \
-h "$DB_HOST" \
-P "$DB_PORT" \
-u "$DB_USER" \
-p"$DB_PASSWORD" \
-D "$DB_NAME" \
-e "SELECT * FROM ${TABLE} ${WHERE};"

;;

INSERT)

echo ""
echo "Rows that will be inserted:"
echo "----------------------------------------------"

grep -A100 "VALUES" "$FILE"

;;

CREATE)

echo ""
echo "New object to be created."
;;

ALTER)

echo ""
echo "Table structure will be modified."
;;

DROP)

echo ""
echo "WARNING"
echo "This operation will permanently remove database objects."

;;

*)

echo "Unsupported SQL."

;;

esac

echo ""
echo "=============================================="
echo "PLAN COMPLETED"
echo "=============================================="
