#!/bin/sh
i=0;
for token in `cat tokens | grep -v \#`; do
echo \#define TOKEN_$token  $i
i=$((i+1))
done