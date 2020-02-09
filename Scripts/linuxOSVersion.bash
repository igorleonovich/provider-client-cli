#!/bin/bash

grep 'DISTRIB_RELEASE' /etc/lsb-release | cut -d'=' -f2
