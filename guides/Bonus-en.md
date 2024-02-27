<h1 align=center>
	<b>Bonus</b>
</h1>

<p align=center>
	The bonus part of the Inception project is a step further into Docker's complexities and a few other services that might be useful to you in the near future (or not, who knows). Just as I've done in the Mandatory part, I will try to keep it as simple as possible, but I will also try to give you a better understanding of the tools and services we are going to use.
</p>

---
<h2 align=center> Index </h2>
<h3 align="center"><b>
	<a href="#Redis">Redis Cache</a>
	<span> • </span>
	<a href="#FTP">FTP Server</a>
	<span> • </span>
	<a href="#Static">Static Website</a>
	<span> • </span>
	<a href="#Adminer">Adminer</a>
	<span> • </span>
	<a href="#cAdvisor">cAdvisor</a>
</b></h3>

---

<h2 id="Redis">
Redis Cache
</h2>

![Redis](./screenshots/redis.png)

But after all, what is Redis? To put it in simple terms, Redis is used as a database, cache, and message broker. Its main purpose is to store data in memory, which makes it a lot faster than traditional databases. It is also a key-value store, which means that it stores data in a dictionary-like structure, where each key is associated with a value. This makes it a great tool for caching, as it can store data in memory and retrieve it quickly.

In this part of the project, we will build a whole container for Redis, and we will also use it to cache the requests made to the API. This will make our application a lot faster, as it will not need to make requests to the database every time a user makes a request to the API.

The standard port for Redis is 6379, and we will use it in our application. We will need to update our docker-compose file appropriately, and we will also need to update our application to use Redis as a cache.

### 1. Install Redis

To start, let's prepare our new container for Redis. We need to install `redis-server`in our container, and we also need to expose the port 6379. We will also need to set the `command` for the container, so it starts the Redis server when the container is started. 

We can also configure the `redis.conf` file to set up a few details about the Redis server. Here's a list of the most important configurations you might want to change:

- `port`: The port the Redis server will listen to. The default is 6379.
- `bind`: The IP address the Redis server will listen to. The default is 127.0.0.1, which means it will only listen to requests from the local machine.

In the end, we will only alter the configuration file in order to comment on the `bind` line. In doing so, we will allow redis service to listen to requests from any host (since Wordpress and Redis are in different containers).

```bash
# bind 127.0.0.1
```

After making sure your Redis server is properly configured, you will also need to set up your Wordpress application to use Redis as a cache. You will need to install the `redis` PHP extension. This can only be done in your Wordpress container. 

Once inside the Wordpress container, edit the `wp-config.php` file once again to enable the Redis cache. You will need to add the following lines to the file:

```php
define( 'WP_REDIS_PORT', '6379' );
define( 'WP_REDIS_HOST', 'redis' );
define( 'WP_CACHE', 'true' );
```

### 2. Install Redis via wp-cli

In order to make sure everything is working properly, you can use wp-cli to install the Redis plugin. You can do this by running the following command:

```bash
wp config set WP_REDIS_HOST redis
wp config set WP_REDIS_PORT 6379
wp config set WP_CACHE true
```

Then, you can use wp-cli to download the Redis plugin:

```bash
wp plugin install redis-cache --activate
wp redis enable
```

### 3. Make sure Redis is working

To make sure Redis is working properly, you can use the `redis-cli` to connect to the Redis server and check if it is working properly. You can also use the `MONITOR` command to check the server's status.


```bash
docker exec -it redis redis-cli

MONITOR -
```

Then, go to your wordpress website and edit or add anything: posts, comments, themes, etc. There will appear all sorts of logs in your terminal. 

![MonitorRedis](./screenshots/redis-monitor.png)

If your screen looks anything like mine, that means that Redis is not only installed and running, but also capturing all the requests made to the database. This means that your application is now using Redis as a cache, and it is a lot faster than it was before.

If you want to check redis info or keys, use the following commands:

```bash
docker exec -it redis redis-cli

INFO
KEYS *
```

### 4. Redis Dockerfile

```Dockerfile
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
```

---
<h2 id="FTP">
FTP Server
</h2>

![FTP](./screenshots/ftp.png)

An FTP server is a software that allows you to transfer files from one computer to another over the internet. It is a very useful tool for web developers, as it allows them to upload files to a server without having to use the command line. It is also a great tool for sharing files with other people, as it allows you to create accounts for other people to access your server.

In this part of the project, we will build a whole container for an FTP server. We will use `vsftpd` as our FTP server, and it will point to the wordpress directory. This means that you will be able to upload files to your wordpress server using an FTP client.

### 1. Install vsftpd

To start, let's prepare the new container for `vsftpd`. You will need to install `vsftpd` in your container, and you will also need to expose the port 21. You will also need to set the `command` for the container, so it starts the `vsftpd` server when the container is started.

To first start the configuration of the `vsftpd` server, you will need to create a new user. This is necessary because the FTP server will need to have a user to authenticate the connections. You can do this by running the following command:

```bash
adduser ftpuser --disabled-password
```

Then, you will need to set the password for the user. You can do this by running the following command:

```bash
echo "ftpuser:password" | chpasswd
```

After creating the user, you will need to configure the `vsftpd` server. The FTP user you just created will need to be on the server user list.

```bash
echo "ftpuser" | tee -a /etc/vsftpd/vsftpd.userlist
```
Then, create the folder where the FTP server will point to. This is the folder where you will be able to upload files to your server. Per the project's requirements, we will point the FTP server to the wordpress directory in your docker-compose file.

```bash
mkdir -p /home/ftpuser/data/wordpress
chown ftpuser:ftpuser /home/ftpuser/data/wordpress
chmod 755 /home/ftpuser/data/wordpress
```

And at last, you will need to edit the `vsftpd.conf` file to set up a few details about the `vsftpd` server. Here's a list of the most important configurations you might want to change:

- `write_enable`: This option allows the FTP user to upload files to the server. The default is commented, and you will need to uncomment it.
- `chroot_local_user`: This option will jail the FTP user to its home directory. The default is commented, and you will need to uncomment it.
- `local_enable`: This option allows the FTP user to log in to the server. You will need to add this line to the file.
- `allow_writeable_chroot`: This option will allow the FTP user to upload files to the server. You will need to add this line to the file.
- `local_root`: This option will set the root directory for the FTP server. You will need to add this line to the file.
- `pasv_enable`: This option will enable passive mode for the FTP server. You will need to add this line to the file.
- `pasv_min_port`: This option will set the minimum port for passive mode. You will need to add this line to the file.
- `pasv_max_port`: This option will set the maximum port for passive mode. You will need to add this line to the file.
- `userlist_file`: This option will set the file with the list of users that can log in to the server. You will need to add this line to the file.

After all that, restart your `vsftpd` service.

### 2. Make sure FTP is working
To make sure the FTP server is working properly, you can upload a file to the server through an FTP client. To do it, you will need to download an FTP client and connect to your server. You can use the following commands:

```bash
docker exec -it ftp bash
apt -y install ftp
ftp localhost
```

Then, you will need to log in to the server using the FTP user you just created. You can use the following commands:

```bash
ftp> open localhost
ftp> Name (localhost:root): ftpuser
ftp> Password: password
```

After logging in, you will need to upload a file to the server. It could be any file of your choice (create one with vim, if you will). You can use the following commands:

```bash
ftp> put file.txt
```

Then, you can check if the file was uploaded to the server by running the following command in you local machine:

```bash
ls /home/$USER/data/wordpress
```

If the file is there, that means that the FTP server is working properly, and you can now upload files to your server using an FTP client.

### 3. FTP Dockerfile

```Dockerfile
FROM        debian:bullseye

# Define build arguments passed from docker-compose.yml
ARG         FTP_USER
ARG         FTP_PASSWORD

# Set environment variables
ENV         FTP_USER=${FTP_USER}
ENV         FTP_PASSWORD=${FTP_PASSWORD}

# Update and upgrade system & install FTP
RUN         apt -y update && apt -y upgrade
RUN         apt -y install vsftpd ftp

# Set up FTP
COPY        ./conf/vsftpd.conf /usr/local/bin/
COPY        ./tools/init.sh /usr/local/bin/
RUN         chmod 755 /usr/local/bin/init.sh

# Expose port
EXPOSE      20 21 21100-21110

# Run FTP
ENTRYPOINT  [ "bash", "/usr/local/bin/init.sh" ]
```

---
<h2 id="Static">
Static Website
</h2>

This part of the project is a bit different from the others. Now, we have free rein to create a static website of our choice. This means that you can create a website about anything you want, and you can use any technology you want. It may seem a bit daunting at first, but it is actually a great opportunity to learn something new and to create something that you can be proud of.

For this part of the project, I decided to create a simple website using React. I chose React because it is a very popular library, and it is also a great tool for creating static websites (and non-static websites as well). 

![Static](./screenshots/react.png)

First, let's understand what a static website is. A static website is a website that is made up of HTML, CSS, and some automation language script (like Javascript). This means that you will not need a server to run your website, and you will not need to use a database to store your data. 

In other words, a static website is a site that is ready at build time, and is served to the user as is. This means that the user will not need to wait for the server to process the request, and the user will not need to wait for the database to retrieve the data. This makes static websites a lot faster than traditional websites, and it also makes them a lot cheaper to host.

For this project, I chose to stretch a little bit of what static means. I chose to use an API to retrieve the data for my website. This means that my website is not entirely static, but since I'm not the one hosting the API, I'm still considering it a static website.

For this part, though, I will not be doing a step-by-step guide. Since this is such an open-ended part of the project, I will leave it to you to figure things out on your own. I will, however, give you a few tips on how to integrate your static website with your whole application.

### 1. Where to host your website

This might seem simple, but the options are actually quite limitless. You can create a container with a server to host you website and simply put it in the same compose file, or you can use the already existing Nginx server to host your website. Also, you might host it on different ports, create different domain names, or even use a different server. The choice is yours.

However, I decided to integrate my site the best I could with the existing infrastructure. I created a new container with only the nodejs and npm installed, and I used it to build my website. Then, I used the Nginx server to host my website through reverse proxy. 

The domain and ports exposed to the public are still the same, so that seemed like a safer bet to me. Also, I had to edit my nginx configuration, and to make maintenance easier, I put my entire source code in a separate volume, so I could edit it without having to rebuild the container.

Now, the only question remained is...

Do you like Pokemon?

---
<h2 id="Adminer">
Adminer
</h2>

![Adminer](./screenshots/adminer.jpg)

Adminer is a database management tool that allows you to manage your databases through a web interface. It is a great tool for web developers, as it allows them to manage their databases without having to use the command line. It is also a great tool for sharing databases with other people, as it allows you to create accounts for other people to access your databases.

In this part of the project, we will build a whole container for Adminer. We will use `adminer` as our database management tool, and it will point to the database. This means that you will be able to manage your database through a web interface.

### 1. Install Adminer

Before installing adminer, you need to make sure you've got the wordpress volume mounted at the /var/www/html directory in your adminer container. Then, you will need to download `adminer` to that folder and make the www-data user the owner of the file. You can do this by running the following commands:

```bash
wget "http://www.adminer.org/latest.php" -O /var/www/html/adminer.php
chown www-data:www-data /var/www/html/adminer.php
chmod 755 /var/www/html/adminer.php
```

### 2. Make sure Adminer is working

To make sure Adminer is working properly, you can access the web interface through your browser. You can do this by going to `localhost/adminer.php` in your browser. You will need to log in to the web interface using your mariadb credentials.

If you can access the web interface, that means that Adminer is working properly, and you can now manage your database through a web interface.

### 3. Adminer Dockerfile

```Dockerfile
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
```

---
<h2 id="cAdvisor">
cAdvisor
</h2>

For the last bonus part, I could choose any service I wanted to integrate with my application. I chose to use cAdvisor, a tool that allows you to monitor your containers through a web interface. It is a great tool for web developers, as it allows them to monitor their containers without having to use the command line. It is also a great tool for sharing containers with other people, as it allows you to create accounts for other people to access your containers.

Also, it's super easy to install and run, so that's a plus.

![cAdvisor](./screenshots/cadvisor.png)

`cAdvisor` is a tool that allows you to monitor your containers through a web interface. It is a great tool for web developers, as it allows them to monitor their containers without having to use the command line. It is also a great tool for sharing containers with other people, as it allows you to create accounts for other people to access your containers.

In this part of the project, we will build a whole container for cAdvisor. We will use `cAdvisor` as our container monitoring tool, and it will point to the docker daemon. This means that you will be able to monitor your containers through a web interface.

### 1. Install cAdvisor

To start, let's prepare the new container for `cAdvisor`. You will need to install `cAdvisor` in your container, and you will also need to expose the port 8080. You will also need to set the `command` for the container, so it starts the `cAdvisor` server when the container is started.

The most important part is to mount the docker volumes to the cAdvisor container. This is necessary because cAdvisor will need to access the docker daemon to monitor the containers. You can do this by adding the following lines to your docker-compose file:

```yaml
volumes:
  - /:/rootfs:ro
  - /var/run:/var/run:rw
  - /sys:/sys:ro
  - /var/lib/docker/:/var/lib/docker:ro
```

### 2. Make sure cAdvisor is working

To make sure cAdvisor is working properly, you can access the web interface through your browser. You can do this by going to `localhost:8080` in your browser. You will need to log in to the web interface using your docker credentials (if you have any).

If you can access the web interface, that means that cAdvisor is working properly, and you can now monitor your containers through a web interface.

### 3. cAdvisor Dockerfile

```Dockerfile
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
```