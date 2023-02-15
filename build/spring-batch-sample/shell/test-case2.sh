#!/bin/sh
random_num="$(($RANDOM % $2 + $1))"

echo "try1. sleep time "$random_num"s"
sleep $random_num"s"

echo "try2. sleep time "$random_num"s"
sleep $random_num"s"

echo "try3. sleep time "$random_num"s"
sleep $random_num"s"

echo "try4. sleep time "$random_num"s"
sleep $random_num"s"

exit $3

