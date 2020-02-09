#!/bin/bash

grep 'DISTRIB_ID' /etc/lsb-release | cut -d'=' -f2
