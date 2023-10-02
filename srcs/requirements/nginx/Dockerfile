# Base image
FROM debian:bullseye 

# Update and upgrade system
RUN apt-get update && apt-get upgrade -y

# Install NGINX and OpenSSL
RUN apt-get update && apt-get install nginx openssl -y

# Generate self-signed certificate
RUN openssl req -x509 -sha256 -nodes \
	-days 365 \
	-newkey rsa:2048 \
	-keyout /etc/ssl/private/nginx-selfsigned.key \
	-out /etc/ssl/certs/nginx-selfsigned.crt \
	-subj "/C=BR/ST=Sao Paulo/L=Sao Paulo/O=42SP/OU=Inception/CN=localhost"

# Copy configuration file
COPY srcs/https.conf /etc/nginx/conf.d/

# Expose ports
EXPOSE 80 443

# Run NGINX
CMD ["nginx", "-g", "daemon off;"]