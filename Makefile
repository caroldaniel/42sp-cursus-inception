# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: cado-car <cado-car@student.42sp.org.br>    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/02/15 09:51:34 by cado-car          #+#    #+#              #
#    Updated: 2024/02/17 17:59:40 by cado-car         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME			= Inception
USER			= cado-car

SYSTEM_USER		= $(shell echo $$USER)
DOCKER_CONFIG 	= $(shell echo $$HOME/.docker)

SRC_DIR			= ./srcs
VOL_DIR			= /home/$(USER)/data

WP_NAME			= wordpress
MDB_NAME		= mariadb

all:		volumes hosts up
			@echo "\n"
			@echo "${GREEN}#-------------------------------------------------------------------------------#${NC}"
			@echo "${GREEN}#\t\tWelcome to ${NAME} by ${USER}\t\t\t\t#${NC}"
			@echo "${GREEN}#\t\tWordpress is running at ${USER}.42.fr\t\t\t\t#${NC}"
			@echo "${GREEN}#\t\tTo access wordpress admin, go to ${USER}.42.fr/wp-admin\t#${NC}"
			@echo "${GREEN}#-------------------------------------------------------------------------------#${NC}"
			@echo "\n"

volumes:
			@echo "${YELLOW}-----Creating Docker Volumes-----${NC}"
			sudo mkdir -p ${VOL_DIR}/${WP_NAME}
			docker volume create --driver local --opt type=none --opt device=${VOL_DIR}/${WP_NAME} --opt o=bind ${WP_NAME}
			sudo mkdir -p ${VOL_DIR}/${MDB_NAME}
			docker volume create --driver local --opt type=none --opt device=${VOL_DIR}/${MDB_NAME} --opt o=bind ${MDB_NAME}
			@echo "${GREEN}-----Volumes Created-----${NC}"

hosts:
			@echo "${YELLOW}-----Editing hosts file with domain name-----${NC}"
			@if ! grep -qFx "127.0.0.1 ${USER}.42.fr" /etc/hosts; then \
				sudo sed -i '2i\127.0.0.1\t${USER}.42.fr' /etc/hosts; \
			fi
			@echo "${GREEN}-----Hosts file edited-----${NC}"

up:
			@echo "${YELLOW}-----Starting Docker-----${NC}"
			sudo docker compose -f ${SRC_DIR}/docker-compose.yml up -d --build
			@echo "${GREEN}-----Docker Started-----${NC}"

down:
			@echo "${YELLOW}-----Stopping Docker-----${NC}"
			@docker compose -f ${SRC_DIR}/docker-compose.yml down
			@echo "${GREEN}-----Docker Stopped-----${NC}"

clean:		down
			@echo "${YELLOW}-----Removing Docker Volumes-----${NC}"
			docker volume rm ${WP_NAME}
			sudo rm -rf /home/$(USER)/data/${WP_NAME}
			docker volume rm ${MDB_NAME}
			sudo rm -rf /home/$(USER)/data/${MDB_NAME}
			@echo "${RED}-----Volumes Removed-----${NC}"
			@echo "${YELLOW}-----Removing domain name from hosts file-----${NC}"
			sudo sed -i '/127\.0\.0\.1\t${USER}\.42\.fr/d' /etc/hosts
			@echo "${RED}-----Hosts file edited-----${NC}"

re:			down all

prepare:	update compose

update:
			@echo "${YELLOW}-----Updating System----${NC}"
			sudo apt -y update && sudo apt -y upgrade
			@if [ $$? -eq 0 ]; then \
				echo "${GREEN}-----System updated-----${NC}"; \
				echo "${YELLOW}-----Installing Docker-----${NC}"; \
				sudo apt -y install docker.io && sudo apt -y install docker-compose; \
				if [ $$? -eq 0 ]; then \
					echo "${GREEN}-----Docker and docker-compose installed-----${NC}"; \
				else \
					echo "${RED}-----Docker or docker-compose installation failed-----${NC}"; \
				fi \
			else \
				echo "${RED}-----System update failed-----${NC}"; \
			fi

compose:
			@echo "${YELLOW}-----Updating Docker Compose to V2-----${NC}"
			sudo apt -y install curl
			mkdir -p ${DOCKER_CONFIG}/cli-plugins
			curl -SL https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-linux-x86_64 -o ${DOCKER_CONFIG}/cli-plugins/docker-compose
			chmod +x ${DOCKER_CONFIG}/cli-plugins/docker-compose
			sudo mkdir -p /usr/local/lib/docker/cli-plugins
			sudo mv /home/${SYSTEM_USER}/.docker/cli-plugins/docker-compose /usr/local/lib/docker/cli-plugins/docker-compose
			@echo "${GREEN}-----Docker Compose updated-----${NC}"

PHONY:		all clean re prepare

# Colors
RED = \033[0;31m
GREEN = \033[0;32m
YELLOW = \033[0;33m
NC = \033[0m