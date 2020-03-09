ENV = prod

# --- GIT ---

REPO = tutorium.git
HIDRIVE = $(shell echo "$$HIDRIVE")$(REPO)
GITHUB = $(shell echo "$$GITHUB")$(REPO)
GITLAB = $(shell echo "$$GITLAB")$(REPO)


init:
	git init
	git remote add origin $(HIDRIVE)
	git remote add github $(GITHUB)
	git remote add gitlab $(GITLAB)
	git add .
	git commit -a -m "initial commit"

push:
	#
	#
	# --- PUSH MASTER TO HIDRIVE ---
	#
	git push origin master
	#
	#
	# --- PUSH MASTER TO GITHUB ---
	#
	git push github master
	#
	#
	# --- PUSH MASTER TO GITLAB ---
	#
	git push gitlab master


# --- DOCKER ---

PROJECT = davidheresy
APP = none
PROXY_APP = proxy
CRYPTO_APP = cyrpto
VERSION = none
IMAGE = $(PROJECT)-$(APP):$(VERSION)
EMAIL = david@familie-haerer.de


build:
	#
	#
	# --- BUILD DOCKER IMAGE ---
	#
	docker image build -t $(IMAGE) .


run:
	#
	#
	# --- RUN DOCKER CONTAINER ---
	#
	docker run -d \
		--name $(APP) \
		-e "LETSENCRYPT_EMAIL=$(EMAIL)" \
		-e "LETSENCRYPT_HOST=$(DOMAIN)" \
		-e "VIRTUAL_HOST=$(DOMAIN)" \
		$(IMAGE)


prune:
	#
	#
	# --- STOP AND REMOVE DOCKER CONTAINER ---
	#
	docker rm -f $(APP) | exit 0
	#
	#
	# --- DOCKER SYSTEM PRUNE ---
	#
	docker system prune
	#
	#
	# --- REMOVE DOCKER IMAGE ---
	#
	docker image rm -f $(IMAGE)


logs:
	#
	#
	# --- PRINT DOCKER CONTAINER LOGS ---
	#
	docker logs $(APP)


attach:
	#
	#
	# --- ATTACH TO DOCKER CONTAINER ---
	#
	docker exec -it $(APP) /bin/bash

