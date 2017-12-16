<@requirement.NAMESPACE 'system' />

<@requirement.CONFORMS>  
  <#assign peers = [] />
  <#assign volumes = [] />
    
  <@cloud.DATACENTER ; dc, index, isLast>
    <#assign peers += ['glusterfs-${dc}-${namespace}.1'] />
  </@cloud.DATACENTER>

  <@swarm.TASK 'glusterfs-client-${namespace}' 'imagenarium/glusterfs-client:3.13u4'>
    <@container.NETWORK 'glusterfs-net-${namespace}' />
    <@container.ENV 'PEERS' peers?join(" ") />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'glusterfs-client-${namespace}' 'global' />
</@requirement.CONFORMS>