# Base image
FROM debian:bullseye 

# Update and upgrade system & install Nginx and OpenSSL
RUN apt -y update && apt -y upgrade
RUN apt -y install nginx openssl

# Generate self-signed certificate
RUN openssl req -x509 -sha256 -nodes \
	-newkey rsa:4096 \
	-days 365 \
	-subj "/C=BR/ST=Sao Paulo/L=Sao Paulo/O=42SP/OU=Inception/CN=cado-car.42.fr" \
	-keyout /etc/ssl/private/nginx-selfsigned.key \
	-out /etc/ssl/certs/nginx-selfsigned.crt 

# Guarantee that Nginx is using TSLv1.3 
RUN sed -i 's/ssl_protocols.*/ssl_protocols TLSv1.3;/' /etc/nginx/nginx.conf

# Copy configuration file
COPY ./conf/https.conf /etc/nginx/conf.d/

# Expose ports
EXPOSE 443

# Run NGINX
CMD ["nginx", "-g", "daemon off;"]