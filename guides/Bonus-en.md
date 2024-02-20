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



---