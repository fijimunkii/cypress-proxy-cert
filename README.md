# cypress-proxy-cert

Allows the use of client certificates when testing with cypress

`docker run -v /path-to-local-cypress-dir:/root/cypress -e S3_BUCKET=encrypted-please -e PROXY_TARGET_URL=my-secure-url.app.com fijimunkii/cypress-proxy-cert:latest`

## Local testing

* Pre-requisite: certs need to be manually added to `proxy-cert/cert`

`PROXY_TARGET_URL=my-secure-url.app.com node proxy-cert/index.js`
`CYPRESS_baseUrl=http://localhost:8000 cypress open`
