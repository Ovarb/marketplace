<@requirement.NAMESPACE 'monitoring' />

<@requirement.PARAM name='PUBLISHED_PORT' value='19999' type='port' />
<@requirement.PARAM name='ADMIN_PASSWORD' value='$apr1$WqbmakdQ$xqF8YxFcUHtO.X20fjgiJ1' />
          
<@img.TASK 'netdata-${namespace}' 'imagenarium/netdata:latest' '' 'global'>
  <@img.BIND '/etc/group' '/host/etc/group' />
  <@img.BIND '/proc' '/host/proc' />
  <@img.BIND '/sys' '/host/sys' />
  <@img.NETWORK 'netdata-net-${namespace}' />
  <@img.CUSTOM '--security-opt apparmor=unconfined' />
</@img.TASK>

<@swarm.SERVICE 'nginx-netdata-${namespace}' 'imagenarium/nginx-basic-auth:latest' '' 'global'>
  <@service.NETWORK 'netdata-net-${namespace}' />
  <@service.PORT PARAMS.PUBLISHED_PORT '8080' 'host' />
  <@service.ENV 'WEB_USER' 'admin' />
  <@service.ENV 'WEB_PASSWORD' PARAMS.ADMIN_PASSWORD 'single' />
  <@service.ENV 'APP_URL' 'http://netdata-${namespace}-{{.Node.ID}}:19999' />
</@swarm.SERVICE>
