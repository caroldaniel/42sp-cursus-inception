<h1 align=center>
	<b>Inception</b>
</h1>

<h2 align=center>
	 <i>42cursus' project #13</i>
</h2>

<p align=center>
	This project aims to broaden your knowledge of system administration by using Docker. You will virtualize several Docker images, creating them in your new personal virtual machine. To do so, you'll need to understand about virtualization, containers, network and so on.
</p>

---
<div align=center>
<h2>
	Final score
</h2>
<img src="" alt="cado-car's 42Project Score"/>
<h4>Completed + Bonus</h4>
<img src="" alt="cado-car's 42Project Badge"/>
</div>

---

<h3 align=center>
Mandatory
</h3>

> <i>For the <b>mandatory</b> part, we should:
> 1. Choose the build images between Alpine or Debian;
> 2. Create Dockerfiles for each service run (they should all be in different containers);
> 3. The Dockerfiles should be caled from a docker-compose.yml file;
> 4. Set up a Docker container that contains NGINX with TLSv1.2 or TLSv1.3 only;
> 5. Set-up a Docker container that contains WordPress + php-fpm (it must be installed and configured) only without nginx;
> 6. Set-up a Docker container that contains MariaDB only without nginx;
> 7. Set up a volume that contains a WordPress database;
> 8. Set up a second volume that contains all the WordPress website files;
> 9. Set up a docker-network that establishes the connection between the containers;
> 10. Set up two users, one of them being the administrator;
> 11. Configure a domain name so it points to your local IP Address. The domain must be <b>login.42.fr</b>, where login is my username, <b>cado-car</b>.</i>

<h3 align=center>
Bonus
</h3>

> <i>For the <b>bonus</b> part we should:
> 1. Set up redis cache for the WordPress website in order to properly manage the cache; 
> 2. Set up a FTP server container pointing to the volume of the WordPress website; 
> 3. Create a simple static website in the language of our choice except PHP (Yes, PHP is excluded!). For example, a showcase site or a site for presenting your resume. 
> 4. Set up <b>Adminer</b>; 
> 5. Set up a service of our choice that we think is useful.</i>

---

<h2>
The project
</h2>

### Implementation Guide

As I've done in the `born2beroot` project, Inception also calls for a complete implementation guide, full of twists and turns and a whole lot of concept explanaitions.

As per usual, do not trust anything I say here. These guides are more for my own benefit then yours. However, I'll be happy if it cahappens to unstuck at least one lost soul in its lifetime.

- Implementation guide for [Mandatory](guides/Mandatory-en.md)
- Implementation guide for the [Bonus](guides/Bonus-en.md)
