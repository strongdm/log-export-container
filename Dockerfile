# latest is very old
FROM fluent/fluentd:edge

USER root
RUN gem install fluent-plugin-rewrite-tag-filter
RUN gem install fluent-plugin-s3
RUN gem install fluent-plugin-cloudwatch-logs

COPY start.sh /start.sh
COPY ./fluentd /fluentd
RUN chown fluent.fluent fluentd/etc/fluent.conf

USER fluent
CMD ["/start.sh"]
