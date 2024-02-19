#!/bin/bash

# Configure Redis
sed -i "s/# requirepass foobared/requirepass $REDIS_PASSWORD/" /etc/redis/redis.conf
sed -i "s/bind 127.0.0.1/# bind 127.0.0.1/" /etc/redis/redis.conf
sed -i "s/maxmemory <bytes>/maxmemory 256mb/" /etc/redis/redis.conf
sed -i "s/maxmemory-policy noeviction/maxmemory-policy allkeys-lru/" /etc/redis/redis.conf