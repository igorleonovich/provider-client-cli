#!/bin/bash

ps -e -o %cpu | awk '{s+=$1} END {print s}'
