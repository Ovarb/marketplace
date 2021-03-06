<@requirement.CONSTRAINT 'es' 'master1' />
<@requirement.CONSTRAINT 'es' 'master2' />
<@requirement.CONSTRAINT 'es' 'master3' />

<@requirement.PARAM name='ES_JAVA_OPTS' value='-Xms1G -Xmx1G -Des.enforce.bootstrap.checks=true' type='textarea' />
<@requirement.PARAM name='PUBLISHED_PORT' type='port' required='false' description='Specify Elasticsearch external port (for example 9200)' />

<#assign ES_VERSION='6.4.0' />

<@img.TASK 'es-router-${namespace}' 'imagenarium/elasticsearch:${ES_VERSION}'>
  <@img.ULIMIT 'nofile=65536:65536' />
  <@img.ULIMIT 'nproc=4096:4096' />
  <@img.ULIMIT 'memlock=-1:-1' />
  <@img.NETWORK 'es-net-${namespace}' />
  <@img.CONSTRAINT 'es' 'master1' />
  <@img.PORT PARAMS.PUBLISHED_PORT '9200' />
  <@img.ENV 'NETWORK_NAME' 'es-net-${namespace}' />
  <@img.ENV 'ES_JAVA_OPTS' PARAMS.ES_JAVA_OPTS />
  <@img.ENV 'bootstrap.memory_lock' 'true' />
  <@img.ENV 'network.bind_host' '0.0.0.0' />
  <@img.ENV 'node.name' 'es-router-${namespace}' />
  <@img.ENV 'node.master' 'false' />
  <@img.ENV 'node.data' 'false' />
  <@img.ENV 'search.remote.connect' 'false' />
  <@img.ENV 'discovery.zen.minimum_master_nodes' '2' />
  <@img.CHECK_PORT '9200' />
</@img.TASK>
  
<#list "1,2,3"?split(",") as index>
  <@img.TASK 'es-master-${index}-${namespace}' 'imagenarium/elasticsearch:${ES_VERSION}'>
    <@img.VOLUME '/usr/share/elasticsearch/data' />
    <@img.NETWORK 'es-net-${namespace}' />
    <@img.CONSTRAINT 'es' 'master${index}' />
    <@img.ULIMIT 'nofile=65536:65536' />
    <@img.ULIMIT 'nproc=4096:4096' />
    <@img.ULIMIT 'memlock=-1:-1' />
    <@img.ENV 'NETWORK_NAME' 'es-net-${namespace}' />
    <@img.ENV 'ES_JAVA_OPTS' PARAMS.ES_JAVA_OPTS />
    <@img.ENV 'bootstrap.memory_lock' 'true' />
    <@img.ENV 'network.bind_host' '0.0.0.0' />
    <@img.ENV 'node.name' 'es-master-${index}-${namespace}' />
    <@img.ENV 'discovery.zen.minimum_master_nodes' '2' />
    <@img.ENV 'discovery.zen.ping.unicast.hosts' 'es-router-${namespace}' />
    <@img.CHECK_PORT '9200' />
  </@img.TASK>
</#list>

<@docker.HTTP_CHECKER 'es-checker-${namespace}' 'http://es-router-${namespace}:9200/_cluster/health?wait_for_status=green&timeout=99999s' 'es-net-${namespace}' />
