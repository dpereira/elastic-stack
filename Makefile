.PHONY: run_% run build_% build stop_% stop setup setup_vm_max_map_count \
	stack stack/.env_% down down_% env_% update_templates

CURRENT_VERSION:=7.12.0

%: export CURRENT_UID:=$(shell echo -n `id -u`:`id -g`)

ifndef VERSION
VERSION:=$(CURRENT_VERSION)
endif

ifndef PROJECT_NAME
PROJECT_NAME:=stack_$(shell echo $(VERSION) | sed 's/\./_/g')
endif

ENV_FILE_VERSION=$(shell echo $(VERSION) | sed 's/\([0-9]*\).*/\1/g')

setup:
	pip install -r requirements.txt

setup_vm_max_map_count:
	sudo sysctl -w vm.max_map_count=262144

run: env
	ELASTICSEARCH_VERSION="$(VERSION)" \
	KIBANA_VERSION="$(VERSION)" \
	LOGSTASH_VERSION="$(VERSION)" \
	ENV_FILE_VERSION=$(ENV_FILE_VERSION) \
	docker-compose -f stack/docker-compose.yml -p $(PROJECT_NAME) up

build: env
	ELASTICSEARCH_VERSION="$(VERSION)" \
	KIBANA_VERSION="$(VERSION)" \
	LOGSTASH_VERSION="$(VERSION)" \
	ENV_FILE_VERSION=$(ENV_FILE_VERSION) \
	docker-compose -f stack/docker-compose.yml -p $(PROJECT_NAME) build

stop:
	docker-compose -f stack/docker-compose.yml -p $(PROJECT_NAME) stop

down:
	docker-compose -f stack/docker-compose.yml -p $(PROJECT_NAME) down

env: 
	make stack/.env_elasticsearch_$(ENV_FILE_VERSION)
	make stack/.env_kibana_$(ENV_FILE_VERSION)
	make stack/.env_logstash-data-loader_$(ENV_FILE_VERSION)

stack/.env_%:
	touch stack/.env_$*

update_templates:
	bash bin/load-index-templates.sh index-templates/ localhost
