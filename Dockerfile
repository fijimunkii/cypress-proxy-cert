FROM cypress/browsers:chrome65-ff57

MAINTAINER Harrison Powers, harrisonpowers@gmail.com

RUN npm i -g cypress@3.0.1 pm2
RUN firefox --version

# Deps for certificate
RUN apt-get update && apt-get install -qq -y curl python-pip libpython-dev libnss3-tools \
  && curl -O https://bootstrap.pypa.io/get-pip.py && python get-pip.py \
  && pip install -q awscli --upgrade

ADD . /root/

WORKDIR /root

# proxy-cert dep
RUN cd proxy-cert && npm i

CMD bash proxy-cert/sync_cert.sh \
  && export CYPRESS_baseUrl=http://localhost:8000 \
  && export CYPRESS_numTestsKeptInMemory=0 \
  && pm2 start proxy-cert/index.js --name proxy-cert --wait-ready > /dev/null \
  && curl $CYPRESS_baseUrl > /dev/null \
  && cypress run
