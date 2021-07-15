# latest is very old
FROM fluent/fluentd:edge

USER root
RUN apk add gettext
RUN apk add build-base ruby-dev
RUN gem install fluent-plugin-rewrite-tag-filter
RUN gem install fluent-plugin-s3
RUN gem install fluent-plugin-cloudwatch-logs
RUN gem install fluent-plugin-splunk-hec
RUN gem install fluent-plugin-datadog
RUN gem install fluent-plugin-azure-loganalytics

COPY start.sh /start.sh
COPY ./fluentd /fluentd
RUN chown fluent.fluent fluentd/etc/fluent.conf

USER fluent
CMD ["/start.sh"]
