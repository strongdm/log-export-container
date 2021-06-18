FROM fluent/fluentd

RUN gem install fluent-plugin-rewrite-tag-filter fluent-plugin-s3
