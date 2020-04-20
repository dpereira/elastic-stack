.PHONY: run_% run

setup:
	pip install -r requirements.txt

setup_vm_max_map_count:
	sudo sysctl -w vm.max_map_count=262144

run: run_7.6.2

run_%: ENV_FILE_VERSION=`echo $* | sed 's/\([0-9]*\).*/\1/g'`
run_%: PROJECT_NAME=stack_`echo $* | sed 's/\./_/g'`

run_%: env_%
	ELASTICSEARCH_VERSION="$*" \
	KIBANA_VERSION="$*" \
	LOGSTASH_VERSION="$*" \
	ENV_FILE_VERSION=$(ENV_FILE_VERSION) \
	docker-compose -f stack/docker-compose.yml -p $(PROJECT_NAME) up

build: build_7.6.2

build_%: ENV_FILE_VERSION=`echo $* | sed 's/\([0-9]*\).*/\1/g'`
build_%: PROJECT_NAME=stack_`echo $* | sed 's/\./_/g'`

build_%: env_%
	ELASTICSEARCH_VERSION="$*" \
	KIBANA_VERSION="$*" \
	LOGSTASH_VERSION="$*" \
	ENV_FILE_VERSION=$(ENV_FILE_VERSION) \
	docker-compose -f stack/docker-compose.yml -p $(PROJECT_NAME) build

down: down_7.6.2

down_%: PROJECT_NAME=stack_`echo $* | sed 's/\./_/g'`

down_%:
	docker-compose -f stack/docker-compose.yml -p $(PROJECT_NAME) down


env_%: 
	make stack/.env_elasticsearch_$(ENV_FILE_VERSION)
	make stack/.env_kibana_$(ENV_FILE_VERSION)
	make stack/.env_logstash_$(ENV_FILE_VERSION)

stack/.env_%:
	touch stack/.env_$*

update_templates:
	bash bin/load-index-templates.sh index-templates/ localhost
