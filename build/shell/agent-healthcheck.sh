#!/bin/sh
if [ $(ps -ef | grep -v grep | grep cname | wc -l) -lt 2 ]; then
  exit 1
else
  exit 0
fi