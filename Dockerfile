FROM fluent/fluentd

RUN gem install fluent-plugin-rewrite-tag-filter
RUN gem install fluent-plugin-s3

COPY ./fluentd /fluentd

CMD ["/fluentd/start.sh"]
