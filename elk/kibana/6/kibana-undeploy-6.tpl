<@requirement.CONFORMS>
  <@docker.REMOVE_HTTP_CHECKER 'kibana-checker-${namespace}' />

  <@swarm.SERVICE_RM 'kibana-${namespace}' />
  <@swarm.SERVICE_RM 'nginx-kibana-${namespace}' />

  <@swarm.NETWORK_RM 'es-net-${namespace}' />
</@requirement.CONFORMS>