FROM fluent/fluentd

RUN gem install fluent-plugin-rewrite-tag-filter
RUN gem install fluent-plugin-s3

COPY start.sh /start.sh
COPY ./fluentd /fluentd

CMD ["/start.sh"]
