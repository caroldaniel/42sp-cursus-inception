FROM        debian:bullseye

# Define build arguments passed from docker-compose.yml
ARG         REDIS_PASSWORD

# Update and upgrade system & install Redis
RUN         apt -y update && apt -y upgrade
RUN         apt -y install redis-server redis-tools

# Expose port
EXPOSE      6379

# Execute Redis Initialization script
COPY        ./tools/init.sh /usr/local/bin/
RUN         bash /usr/local/bin/init.sh

# Run Redis
ENTRYPOINT  [ "redis-server", "--protected-mode", "no" ]

