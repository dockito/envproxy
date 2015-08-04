import { join } from 'path';
import { writeFileSync } from 'fs';
import url from 'url';
import swig from 'swig';
import camelCase from 'camelcase';


const REGEX_PROXY_PREFIX = /^PROXY_.*$/;
const REGEX_PROXY_KEYS = /^PROXY_(\d+)_(.+)$/;
const NGINX_SRC_PATH = join(__dirname, '../nginx.tmpl');
const NGINX_DEST_PATH = process.env.NGINX_DEST_PATH || '/etc/nginx/conf.d/envproxy.conf';


/**
 * generates the nginx file based in the environment variables
 */
export function nginxProxies() {
  const configs = {
    proxies: getConfigurationsFromEnv()
  };

  const nginxFile = swig.renderFile(NGINX_SRC_PATH, configs);

  writeFileSync(NGINX_DEST_PATH, nginxFile);
}


function getConfigurationsFromEnv() {
  const configs = Object.keys(process.env)
    .filter(e => REGEX_PROXY_PREFIX.test(e))
    .reduce((p, n) => {
      const [env, id, key] = n.match(REGEX_PROXY_KEYS);

      if (!p[id]) {
        p[id] = { proxyName: `proxy_${id}` };
      }

      p[id][camelCase(key)] = process.env[env];

      if (key === 'HOST') {
        p[id].host = url.parse(p[id].host).host;
      }

      return p;
    }, {});

  return Object.keys(configs).map(key => configs[key]);
}
