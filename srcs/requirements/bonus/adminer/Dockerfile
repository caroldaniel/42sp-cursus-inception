# Base image
FROM        debian:bullseye

# Update and upgrade system & install wget and php
RUN         apt -y update && apt -y upgrade
RUN         apt -y install wget 

# Copy Entrypoint script
COPY        ./tools/entrypoint.sh /usr/local/bin/
RUN         chmod 755 /usr/local/bin/entrypoint.sh

# Run entrypoint script
ENTRYPOINT  [ "bash", "/usr/local/bin/entrypoint.sh" ]