<@requirement.CONFORMS>
  <@swarm.SERVICE_RM 'nsf-filestorage-${namespace}' />
  <@swarm.SERVICE_RM 'nsf-temp-${namespace}' />
  <@swarm.SERVICE_RM 'swarmstorage-nfs-${namespace}' />
  <@swarm.NETWORK_RM 'nfs-net-${namespace}' />
</@requirement.CONFORMS>