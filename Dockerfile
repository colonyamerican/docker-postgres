FROM ubuntu

RUN apt-get update && apt-get install -y wget ca-certificates

RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main' > /etc/apt/sources.list.d/pgdg.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

RUN apt-get update
RUN apt-get -y install libpq-dev postgresql-9.3 postgresql-9.3-postgis-2.1 postgresql-9.3-postgis-scripts libpq-dev postgresql-contrib

RUN apt-get purge -y wget ca-certificates && apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp*

RUN mkdir -p /var/run/postgresql && chown -R postgres /var/run/postgresql

ENV PATH /usr/lib/postgresql/9.3/bin:$PATH
ENV PGDATA /data

VOLUME /data

RUN chown -R postgres /data

COPY ./docker-entrypoint.sh /
RUN chmod +x docker-entrypoint.sh

EXPOSE 5432

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["postgres"]
