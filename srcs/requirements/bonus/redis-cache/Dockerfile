FROM        debian:bullseye

# Update and upgrade system & install Redis
RUN         apt -y update && apt -y upgrade
RUN         apt -y install redis-server redis-tools

# Expose port
EXPOSE      6379

# Create PID directory for Redis
RUN         mkdir -p /run/redis
RUN         chmod 755 /run/redis

# Configure Redis
RUN         cp /etc/redis/redis.conf /etc/redis/redis.conf.bak
RUN         sed -i 's/bind 127.0.0.1/#bind 127.0.0.1/' /etc/redis/redis.conf

# Run Redis
ENTRYPOINT  [ "redis-server", "--protected-mode", "no" ]