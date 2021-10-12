# latest is very old
FROM fluent/fluentd:edge

ENV FLUENTD_DIR=fluentd

USER root
RUN apk add gettext
RUN apk add build-base ruby-dev

COPY configure-environment.sh /configure-environment.sh
RUN sh /configure-environment.sh

COPY fluentd /fluentd
COPY create-conf-file.sh /create-conf-file.sh
COPY start.sh /start.sh
RUN chown fluent.fluent fluentd/etc/fluent.conf

USER fluent
CMD ["/start.sh"]
