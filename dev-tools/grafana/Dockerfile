FROM grafana/grafana

ENV GF_AUTH_DISABLE_LOGIN_FORM="true"
ENV GF_AUTH_ANONYMOUS_ENABLED="true"
ENV GF_AUTH_ANONYMOUS_ORG_ROLE="Admin"

COPY grafana.ini /etc/grafana/
COPY init.sql /

USER root
RUN apk add sqlite

RUN sqlite3 /var/lib/grafana/grafana.db < /init.sql
RUN rm /init.sql

USER grafana
