# Base image
FROM 		debian:bullseye

# Update and upgrade system & install wget
RUN 		apt -y update && apt -y upgrade
RUN 		apt -y install wget 

# Change working directory
WORKDIR		/usr/local/bin

# Download and install cAdvisor
RUN 		wget https://github.com/google/cadvisor/releases/download/v0.39.0/cadvisor
RUN 		chmod +x cadvisor

# Execute cAdvisor
ENTRYPOINT	[ "cadvisor" ]