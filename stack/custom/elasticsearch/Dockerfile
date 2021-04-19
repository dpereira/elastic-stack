ARG ELASTICSEARCH_VERSION

FROM docker.elastic.co/elasticsearch/elasticsearch:${ELASTICSEARCH_VERSION:-7.3.2}

COPY config/elasticsearch.yml /tmp/elasticsearch.yml

RUN cat /tmp/elasticsearch.yml >> /usr/share/elasticsearch/config/elasticsearch.yml

ADD config/jvm.options.d /usr/share/elasticsearch/config/jvm.options.d
