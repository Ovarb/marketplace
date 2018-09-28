<@requirement.CONS 'phoenix' 'true' />

<@requirement.PARAM name='ADMIN_MODE'  value='false' type='boolean' />
<@requirement.PARAM name='RUN_APP'     value='true'  type='boolean' />

<@requirement.CONFORMS>
  <#assign PHOENIX_VERSION='4.14_1' />

  <#assign zoo_hosts = [] />
  
  <#list 1..3 as index>
    <#assign zoo_hosts += ['zookeeper-${index}-${namespace}-1'] />
  </#list>

  <@swarm.TASK 'phoenix-${namespace}'>
    <@container.HOST_NETWORK />
    <@container.ENV 'HBASE_CONF_hbase_zookeeper_quorum' zoo_hosts?join(",") />
    <@container.ENV 'STORAGE_SERVICE' 'swarmstorage' />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'phoenix-${namespace}' 'imagenarium/phoenix:${PHOENIX_VERSION}'>
    <@service.CONS 'node.labels.phoenix' 'true' />
    <@service.ENV 'IMAGENARIUM_ADMIN_MODE' PARAMS.ADMIN_MODE />
    <@service.ENV 'IMAGENARIUM_RUN_APP' PARAMS.RUN_APP />
  </@swarm.TASK_RUNNER>
  
  <@docker.TCP_CHECKER 'phoenix-checker-${namespace}' 'phoenix-${namespace}-1:8765' />
</@requirement.CONFORMS>