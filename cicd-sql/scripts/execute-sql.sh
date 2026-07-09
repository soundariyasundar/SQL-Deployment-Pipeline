#!/bin/bash
set -e

FILE=$1

echo "======================================"
echo "Executing SQL Deployment..."
echo "======================================"

mysql \
-h "$DB_HOST" \
-P "$DB_PORT" \
-u "$DB_USER" \
-p"$DB_PASSWORD" \
"$DB_NAME" < "$FILE"

echo ""
echo "======================================"
echo "SUCCESS: SQL Executed Successfully"
echo "======================================"

echo ""
echo "The salary has been updated successfully."
echo ""

echo "Updated Employee Details:"
echo "--------------------------------------"

mysql \
-h "$DB_HOST" \
-P "$DB_PORT" \
-u "$DB_USER" \
-p"$DB_PASSWORD" \
"$DB_NAME" \
-e "SELECT emp_id, emp_name, salary FROM employees WHERE emp_id = 1;"

echo "--------------------------------------"
echo "Deployment Completed Successfully"
