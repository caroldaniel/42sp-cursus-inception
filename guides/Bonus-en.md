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

To start, let's prepare our new container for Redis. We need to install `redis-server`in our container, and we also need to expose the port 6379. We will also need to set the `command` for the container, so it starts the Redis server when the container is started. 

We can also configure the `redis.conf` file to set up a few details about the Redis server. Here's a list of the most important configurations you might want to change:

- `port`: The port the Redis server will listen to. The default is 6379.
- `bind`: The IP address the Redis server will listen to. The default is 127.0.0.1, which means it will only listen to requests from the local machine.
- `requirepass`: The password required to access the Redis server. The default is empty.
- `maxmemory`: The maximum amount of memory the Redis server can use. The default is 0, which means no limit.
- `maxmemory-policy`: The policy used to remove data from the Redis server when it reaches the maximum memory. The default is `noeviction`, which means the server will return an error when the memory limit is reached.
- `appendonly`: If set to `yes`, the Redis server will write every command to a file, so it can be recovered in case of a crash. The default is `no`.

In the end, we will alter the configuration file in order to comment on the `bind` line, so that the Redis server listens to requests from any IP address, and we will also set the `requirepass`,  `maxmemory` and `maxmemory-policy` lines.

```bash
# bind 127.0.0.1
requirepass your_password
maxmemory 256mb
maxmemory-policy allkeys-lru
```

After making sure your Redis server is properly configured, you will also need to set up your Wordpress application to use Redis as a cache. You will need to install the `redis` PHP extension. This can only be done in your Wordpress container. 

Once inside the Wordpress container, edit the `wp-config.php` file once again to enable the Redis cache. You will need to add the following lines to the file:

```php
define('WP_REDIS_HOST', 'redis');
define('WP_REDIS_PORT', 6379);
define('WP_REDIS_PASSWORD', 'your_password');

define('WP_CACHE', true);
```

### Make sure Redis is working

To make sure Redis is working properly, you can use the `redis-cli` to connect to the Redis server and check if it is working properly. You can also use the `INFO` command to check the server's status.


```bash
docker exec -it redis redis-cli -a your_password
info
```

### Redis Dockerfile

```Dockerfile
FROM        debian:bullseye

# Define build arguments passed from docker-compose.yml
ARG         REDIS_PASSWORD

# Update and upgrade system & install Redis
RUN         apt -y update && apt -y upgrade
RUN         apt -y install redis-server

# Expose port
EXPOSE      6379

# Execute Redis Initialization script
COPY        ./tools/init.sh /usr/local/bin/
RUN         bash /usr/local/bin/init.sh

# Run Redis
ENTRYPOINT  [ "redis-server", "--protected-mode", "no" ]
```

---



---
