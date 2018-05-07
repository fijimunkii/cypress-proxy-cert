const fs = require('fs');
const path = require('path');
const httpProxy = require('http-proxy');

const proxy = httpProxy.createProxyServer({
  target: {
    protocol: 'https:',
    host: process.env.PROXY_TARGET_URL,
    port: 443,
    pfx: fs.readFileSync(path.join(__dirname,'cert/cert.p12')),
    passphrase: fs.readFileSync(path.join(__dirname,'cert/cert.p12.pass'))
      .toString().replace(/[^a-z0-9]/gi,'')
  },
  changeOrigin: true
});

proxy.on('error', e => console.log(e));

// Remove "Secure" from set-cookie header to allow on localhost
proxy.on('proxyRes', function (proxyRes, req, res) {
  const cookieHeader = proxyRes.headers['set-cookie'] && proxyRes.headers['set-cookie'][0];
  if (cookieHeader)
    proxyRes.headers['set-cookie'][0] = cookieHeader.replace(/; Secure/gi,'');
});

proxy.listen(8000);

console.log('proxy-cert listening on port 8000');
process.send('ready'); // signal ready for `pm2 start index.js --wait-ready`
