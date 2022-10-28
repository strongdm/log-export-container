FROM fluent/fluentd:edge-debian

ENV FLUENTD_DIR=/fluentd

USER root
RUN apt-get update && \
    apt-get install -y \
        build-essential \
        curl \
        ca-certificates \
        gettext \
        jq \
        ruby-dev \
        zlib1g-dev && \
    gem install bundler -v '~> 2.3.3' && \
    apt-get autoclean && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /root/.cache /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY Gemfile /Gemfile
COPY .gemspec /.gemspec
RUN bundle install

COPY fluentd /fluentd
COPY create-conf.rb /create-conf.rb
COPY conf-utils.rb /conf-utils.rb
COPY start.rb /start.rb

RUN curl -fsSLo sdm.zip \
    $(curl https://app.strongdm.com/releases/upgrade\?os\=linux\&arch\=$(uname -m | sed -e 's:x86_64:amd64:' -e 's:aarch64:arm64:')\&software\=sdm-cli\&version\=productionexample | jq ".url" -r) && \
    unzip -x sdm.zip && \
    rm -f sdm.zip && \
    mv sdm /bin && \
    mkdir -p /root/.sdm

CMD ["ruby", "/start.rb"]
