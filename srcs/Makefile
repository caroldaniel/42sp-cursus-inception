# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: cado-car <cado-car@student.42sp.org.br>    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/02/15 09:51:34 by cado-car          #+#    #+#              #
#    Updated: 2024/02/15 20:23:01 by cado-car         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

USER =	cado-car

install:	
			@echo "${YELLOW}-----Installing Docker-----${NC}"
			sudo apt -y update && sudo apt -y upgrade
			@if [ $$? -eq 0 ]; then \
				echo "${GREEN}-----System updated-----${NC}"; \
				echo "${YELLOW}-----Installing Docker-----${NC}"; \
				sudo apt -y install docker.io; \
				if [ $$? -eq 0 ]; then \
					echo "${GREEN}-----Docker installed-----${NC}"; \
				else \
					echo "${RED}-----Docker installation failed-----${NC}"; \
				fi \
			else \
				echo "${RED}-----System update failed-----${NC}"; \
			fi

PHONY: all clean fclean re install

# Colors
RED = \033[0;31m
GREEN = \033[0;32m
YELLOW = \033[0;33m
NC = \033[0m
		