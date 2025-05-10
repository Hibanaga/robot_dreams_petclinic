#!/bin/bash

echo "Collection unique X-Served-By values..."

for i in {1..100}; do
  curl -s -D - http://localhost:8080 -o /dev/null | grep -i 'X-Served-By'
done  | sort | uniq