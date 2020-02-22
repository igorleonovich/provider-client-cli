#!/bin/bash

installed_memory=$(sysctl -n hw.memsize)
installed_memory_in_kb=$(bc <<< "scale=2; $installed_memory/1000")
page_types=("wired down" "active" "inactive")
all_consumed=0
for page_type in "${page_types[@]}"; do
    consumed=$(vm_stat | grep "Pages ${page_type}:" | awk -F: '{print $2}' | tr -d '[[:space:]]' | grep -e "[[:digit:]]*" -ho)
    consumed_kb=$(bc <<< "scale=2; ($consumed*4096)/1000")
    all_consumed=$(bc <<< "scale=2; $all_consumed+$consumed_kb")
done
printf "%.0f" $(bc <<< "scale=2; $installed_memory_in_kb-$all_consumed")
