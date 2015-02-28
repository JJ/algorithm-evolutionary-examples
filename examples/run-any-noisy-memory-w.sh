#!/bin/bash

CONF=$1

for i in {1..30}
do
    echo "Test $i"
    ./anyfitness-noisy-memory-w-lted.pl $CONF
done
