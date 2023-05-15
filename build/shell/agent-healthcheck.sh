#!/bin/sh
if [ $(ps -ef | grep -v grep | grep "cname=agent" | wc -l) -ne 1 ]; then
  exit 1
else
  exit 0
fi