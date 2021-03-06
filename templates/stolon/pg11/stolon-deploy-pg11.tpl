<@requirement.CONSTRAINT 'sentinel' '1' />
<@requirement.CONSTRAINT 'sentinel' '2' />
<@requirement.CONSTRAINT 'sentinel' '3' />
<@requirement.CONSTRAINT 'keeper' '1' />
<@requirement.CONSTRAINT 'keeper' '2' />
<@requirement.CONSTRAINT 'proxy' 'true' />

<@requirement.PARAM name='PUBLISHED_PORT' type='port' required='false' description='Specify postgres external port (for example 5432)' />
<@requirement.PARAM name='POSTGRES_USER' value='postgres' />
<@requirement.PARAM name='POSTGRES_PASSWORD' value='postgres' />
<@requirement.PARAM name='POSTGRES_PARAMS' value='\"max_connections\":\"1000\"' />

<#if PARAMS.DELETE_DATA == 'true'>
  <@docker.CONTAINER 'stolon-init-${namespace}' 'imagenarium/stolon:pg11'>
    <@container.NETWORK 'net-${namespace}' />
    <@container.ENV 'ROLE' 'INIT' />
    <@container.ENV 'POSTGRES_PARAMS' PARAMS.POSTGRES_PARAMS />
    <@container.EPHEMERAL />
  </@docker.CONTAINER>
</#if>

<#list 1..3 as index>
  <@swarm.SERVICE 'stolon-sentinel-${index}-${namespace}' 'imagenarium/stolon:pg11'>
    <@service.NETWORK 'net-${namespace}' />
    <@service.CONSTRAINT 'sentinel' '${index}' />
    <@service.ENV 'ROLE' 'SENTINEL' />
    <@service.CHECK_PORT '8585' />
  </@swarm.SERVICE>
</#list>

<#list 1..2 as index>
  <@swarm.SERVICE 'stolon-keeper-${index}-${namespace}' 'imagenarium/stolon:pg11'>
    <@service.NETWORK 'net-${namespace}' />
    <@service.VOLUME '/var/lib/postgresql/data' />
    <@service.CONSTRAINT 'keeper' '${index}' />
    <@service.ENV 'ROLE' 'KEEPER' />
    <@service.ENV 'KEEPER_ID' '${index}' />
    <@service.ENV 'NETWORK_NAME' 'net-${namespace}' />
    <@service.ENV 'POSTGRES_USER' PARAMS.POSTGRES_USER />
    <@service.ENV 'POSTGRES_PASSWORD' PARAMS.POSTGRES_PASSWORD />
  </@swarm.SERVICE>
</#list>

<#list 1..2 as index>
  <@docker.TCP_CHECKER 'cluster-checker-${namespace}' 'stolon-keeper-${index}-${namespace}:5432' 'net-${namespace}' />
</#list>

<@swarm.SERVICE 'stolon-proxy-${namespace}' 'imagenarium/stolon:pg11'>
  <@service.NETWORK 'net-${namespace}' />
  <@service.PORT PARAMS.PUBLISHED_PORT '5432' />
  <@service.CONSTRAINT 'proxy' 'true' />
  <@service.ENV 'ROLE' 'PROXY' />
  <@service.CHECK_PORT '5432' />
</@swarm.SERVICE>