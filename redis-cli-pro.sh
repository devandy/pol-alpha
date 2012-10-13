#!/bin/bash

set -e
~/dev/redis-2.4.17/src/redis-cli -h fish.redistogo.com -p 9201 -a $1