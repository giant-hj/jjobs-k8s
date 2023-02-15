#!/bin/sh
random_num="$(($RANDOM % $2 + $1))"
echo "sleep time "$random_num"s"
sleep $random_num"s"
exit $3

