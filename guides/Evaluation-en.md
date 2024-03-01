<h1 align=center>
	<b>Evaluation Guide</b>
</h1>

### 1. Cloning the repository

```shell
git clone <repo_url> <local_directory>
cd <local_directory>
```

### 2. `.env` file

First thing to do, make sure the `.env` file is properly set up.

```shell
touch srcs/.env
```

Then, make sure (using the editor of your choice), that it has all appropriate variables set up. You can use `nano` for that.

```shell
nano srcs/.env
```

```
DOMAIN_NAME=cado-car.42.fr

CERTS_KEY=/etc/ssl/private/nginx-selfsigned.key
CERTS_CRT=/etc/ssl/certs/nginx-selfsigned.crt

MYSQL_DATABASE=WordpressDB
MYSQL_ROOT_PASSWORD=1234root4321
MYSQL_USER=cado-car
MYSQL_PASSWORD=1234mysql4321

FTP_USER=cado-car
FTP_PASSWORD=1234ftp4321

```

### 3. Installing prerequisites

Make sure all the prerequisites are installed, and that your machine is working with `docker compose` v2. There's already a make rule for that (two in fact).

```shell
make prepare # install all prerequisites
make compose # install docker compose v2
```

### 4. Cleaning previous docker containers

If you're using a machine that already has docker installed, maybe from some previous evaluation, you might want to clean it up before running this project. You can use the following commands to do so.

```shell
docker stop $(docker ps -qa) # stop all running containers
docker rm $(docker ps -qa) # remove all containers
docker rmi $(docker images -qa) # remove all images
docker volume rm $(docker volume ls -q) # remove all volumes
docker network rm $(docker network ls -q) # remove all networks
```

### 5. Running the project

```shell
make
```

### 6. Are the containers running?

```shell
cd srcs
docker compose ps
```

You need to make sure all containers (in my case, all eight of them) are running.


### 7. Is the network set up?

```shell
docker network ls
```

If you want to check the details of the network, you can use the following command:

```shell
docker network inspect <network_name>
```

### 8. Is the volume set up?

```shell
docker volume ls
```
To check information about a specific volume, you can use the following command:

```shell
docker volume inspect <volume_name>
```

### 9. Is the website up?

Open your browser and go to `https://cado-car.42.fr`. You should see the website up and running.

Another way to do it is to use `curl`. Make sure to indicate the port 443, as it's the one used for HTTPS connections:

```shell
curl cado-car.42.fr:443
```

Trying to access the website using port 80 should not work:

```shell
curl cado-car.42.fr:80
```

You should get a `Connection refused` message:

```shell
curl: (7) Failed to connect to cado-car.42.fr port 80: Connection refused
```

### 10. Does the website use the correct certificate?

You can use the `openssl` command to check the certificate.

```shell
openssl s_client -connect cado-car.42.fr:443
```

You should see the certificate information.

```
CONNECTED(00000003)
depth=0 C = BR, ST = Sao Paulo, L = Sao Paulo, O = 42SP, OU = Inception, CN = cado-car.42.fr
```

Below that, you can make sure it uses TLSv1.2 or TLSv1.3.

```
SSL-Session:
    Protocol  : TLSv1.3
    Cipher    : TLS_AES_256_GCM_SHA384
```

### 11. Is the mariadb database up?

```shell
docker exec -it mariadb mysql -u cado-car -p
```

Type in the password (see .env file) and you should be able to access the database.

```mysql
use WordpressDB;
show tables;
```

You should see the tables of the Wordpress database.

```
+-----------------------+
| wp_commentmeta        |
| wp_comments           |
| wp_links              |
| wp_options            |
| wp_postmeta           |
| wp_posts              |
| wp_term_relationships |
| wp_term_taxonomy      |
| wp_termmeta           |
| wp_terms              |
| wp_usermeta           |
| wp_users              |
+-----------------------+
```

### 12. Is wordpress correctly set up?

You can check the configuration of the wordpress website by accessing the `wp-config.php` file. You can do so locally, since the wordpress volume is pointing to an external directory.

```shell
cat /home/cado-car/data/wordpress/wp-config.php
```

You should see the configuration of the wordpress website in full.

Now, to check the website itself, you can access it through the browser. You should see the website up and running.

There are 2 users: One adminer, `oxymoron` and one regular user, `Harrison Forged`. You can log in with both of them and check the website.

```
username: oxymoron
password: 1234oxy4321
```

```
username: harrisonforged
password: 1234forged4321
```

### Bonus evaluation

#### 1. Is the redis cache set up?

The easiest way to check if the redis cache is set up is to monitor the cache managed by the redis server. You can do so by accessing the redis-cli.

```shell
docker exec -it redis redis-cli
```

Then, you can use the `monitor` command to see all the commands being executed.

```shell
monitor
```

Then, access the website and see if the cache is being managed. Make comments, posts, and so on, and see if the cache is being updated.

#### 2. Is the FTP server set up?

You can use an FTP client to check if the FTP server is set up. You can use the ftp command inside the ftp container, or connect to the ftp client through wordpress container.

To do so directly from the ftp container, you can use the following command:

```shell
docker exec -it ftp bash
```

Create a simple file to test the FTP server.

```shell
echo "Hello, FTP server!" >> hello_ftp.txt
```

Then, you can use the `ftp` command to connect to the server.

```shell
ftp localhost
```

Type in the FTP_USER and FTP_PASSWORD from the .env file, and you should be able to access the server. Finally, try to upload the file you created.

```shell
put hello_ftp.txt
```

If the command exited correctly, you should be able to see the file in the wordpress volume. Access it locally, if you want. 

#### 3. Is the simple static website set up?

You can access the simple static website by going to `https://cado-car.42.fr/static`. You should see my pokemon search website.

#### 4. Is Adminer set up?

You can access the adminer website by going to `https://cado-car.42.fr/adminer.php`. In there, you can access the WordpressDB with the credentials from the .env file. 

If you want, you can edit the database directly from the adminer interface, add comments, users, and so on. The changes you make there should reflect in the wordpress website.

#### 5. Is the service of our choice set up?

In my case, cAdvisor is the service of my choice. You can access it by going to `https://cado-car.42.fr:8080`. You should see the cAdvisor interface.

You can check the containers running, the resources they're using, and so on. It's a very useful tool to monitor the containers running in your machine.

