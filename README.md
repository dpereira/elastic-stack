# Elastic Stack Sandbox

Sandbox repository for playing around with Elastic Stack projects.

## Setup

You'll need some python 3+. And:

```
$ make setup
```

Current versions of Elasticsearch require a higher `vm.max_map_count` setting then some OS's specify. To workaround
that issue, you can run

```
$ make setup_vm_max_map_count
```

Which will sudo and run _sysctl_ for setting that configuration with an acceptable value. You can do that yourself,
however. Take a look at the [documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html)
in case of doubt on how to proceed.

## Usage

```
$ make run
```

Will bring up a single-node ES cluster with a Kibana instance to match.

Versions default to 7.3.2 but can be changed with:

```
$ make run_<version>
```

E.g.:

```
$ make run_6.7.2
```

If not already created `.env` files are initialized in the `stack` directory:

 - `stack/.env_elasticsearch_<major version>`
 - `stack/.env_kibana_<major version>`

These files can be used to customize the configuration of that specific stack component.
Some are already provided when default config settings are required for the component execution.

To use the instances just:

 - Elasticsearch: http://localhost:9200
 - Kibana: http://localhost:5601

# Custom Ports

If you want to run multiple instances, or for any reason change the default ports, set the following variables:

- `ELASTICSEARCH_PORT`
- `KIBANA_PORT`

E.g.:

```
$ ELASTICSEARCH_PORT=9299 KIBANA_PORT=5699 make run
```
