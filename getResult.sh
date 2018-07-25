#!/bin/bash
set -u
set -e

rm -rf result
mkdir result
containers=$(docker ps | grep "quorum-api:latest" | awk '{ print $1 }')
var=1
for container in $containers
do
  docker cp $container:/blockchain/result.csv $PWD/result/"result$var.csv"
  ((var++))
done