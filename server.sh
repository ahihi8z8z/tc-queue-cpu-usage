#! /bin/bash

for (( i=1; i<=$1; i++ ))
do
    port=$(($i+1000))
    #echo $port
    iperf -s -p "$port" -t 60 & 
done
