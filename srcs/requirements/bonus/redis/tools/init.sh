#!/bin/bash

# Configure Redis
sed -i "s/bind 127.0.0.1 ::1/# bind 127.0.0.1 ::1/" /etc/redis/redis.conf
sed -i "s/protected-mode yes/protected-mode no/" /etc/redis/redis.conf
sed -i "s/# maxmemory <bytes>/maxmemory 256mb/" /etc/redis/redis.conf
sed -i "s/# maxmemory-policy noeviction/maxmemory-policy allkeys-lru/" /etc/redis/redis.conf
sed -i "s/supervised no/supervised systemd/" /etc/redis/redis.conf
echo "\n\
monitoring on\
" | tee -a /etc/redis/redis.conf