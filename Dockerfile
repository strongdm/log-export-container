# latest is very old
FROM fluent/fluentd:edge

USER root
RUN apk add gettext
RUN apk add build-base ruby-dev

RUN mkdir setup

COPY configure_environment.sh /setup/
COPY Gemfile /Gemfile

RUN sh /setup/configure_environment.sh

COPY start.sh /start.sh
COPY ./fluentd /fluentd
RUN chown fluent.fluent fluentd/etc/fluent.conf

ENV FLUENTD_DIR=/fluentd

USER fluent
# CMD ["/start.sh"]
