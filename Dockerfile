# latest is very old
FROM fluent/fluentd:edge

ENV FLUENTD_DIR=fluentd

USER root
RUN apk add gettext
RUN apk add build-base ruby-dev

COPY configure_environment.sh /configure_environment.sh
COPY Gemfile /Gemfile

RUN sh /configure_environment.sh

COPY create_conf_file.sh /create_conf_file.sh

COPY start.sh /start.sh
COPY ./fluentd /fluentd
RUN chown fluent.fluent fluentd/etc/fluent.conf

USER fluent
CMD ["/start.sh"]
