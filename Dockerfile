# latest version is older
FROM fluent/fluentd:edge

ENV FLUENTD_DIR=fluentd
ENV PATH="/root:$PATH"

USER root
RUN apk add gettext
RUN apk add build-base ruby-dev zlib-dev
RUN gem install bundler -v '~> 2.3.3'

COPY Gemfile /Gemfile
RUN bundle install

RUN apk --no-cache add curl ca-certificates wget
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-2.28-r0.apk
RUN apk add glibc-2.28-r0.apk

RUN curl -J -O -L https://app.strongdm.com/releases/cli/linux
RUN unzip -x sdm*.zip
RUN rm sdm*.zip
RUN mv sdm /root
RUN apk del curl ca-certificates wget
RUN mkdir /root/.sdm

COPY fluentd /fluentd
COPY create-conf.rb /create-conf.rb
COPY conf-utils.rb /conf-utils.rb
COPY start.sh /start.sh

CMD ["/start.sh"]
