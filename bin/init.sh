
ES_HOST=${2:-elasticsearch}
TEMPLATES_DIR=$1

up() {
    is_up=$(curl http://$ES_USER:$ES_PASS@$ES_HOST:9200 -svI | grep '200 OK' | wc -l)
    echo 'ES is up: ' $is_up
    return $is_up
}

up

while [ $? == 0 ]; do sleep 1; up; done


for f in $(ls $TEMPLATES_DIR);
do
    echo "Loading template $f";
    curl -XPUT "http://$ES_USER:$ES_PASS@$ES_HOST:9200/_template/`echo -n $f | sed 's/\..*//g'`" -d @"$TEMPLATES_DIR/$f" -H 'Content-Type: application/json';
done
