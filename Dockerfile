# latest is very old
FROM fluent/fluentd:edge

ENV FLUENTD_DIR=fluentd

USER root
RUN apk add gettext
RUN apk add build-base ruby-dev zlib-dev
RUN gem install bundler -v '~> 2.3.3'

COPY Gemfile /Gemfile
COPY Gemfile.lock /Gemfile.lock
RUN bundle install

COPY fluentd /fluentd
COPY create-conf-file.sh /create-conf-file.sh
COPY start.sh /start.sh
RUN chown fluent.fluent fluentd/etc/fluent.conf

USER fluent
CMD ["/start.sh"]
