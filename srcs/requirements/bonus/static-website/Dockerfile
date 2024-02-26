# Base image
FROM 		debian:bullseye

# Update and upgrade system & install nodejs and npm
RUN 		apt -y update && apt -y upgrade
RUN 		apt -y install nodejs npm

# Create the working directory
RUN			mkdir -p /usr/src/app

# Set the working directory
WORKDIR		/usr/src/app

# Copy the package.json file
COPY		./conf/package*.json .

# Install the dependencies
RUN			npm install

# Copy the source code
RUN         mkdir -p /usr/src/app/public
COPY        ./srcs/public/* /usr/src/app/public/
RUN         mkdir -p /usr/src/app/src
COPY        ./srcs/src/* /usr/src/app/src/

# Expose port
EXPOSE		3000

# Run the application
ENTRYPOINT	[ "npm", "start" ]