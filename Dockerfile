FROM crunchydata/crunchy-postgres-gis:centos7-11.5-2.4.2

USER root

RUN localedef -c -i de_CH -f UTF-8 de_CH.UTF-8 && \
    localedef -c -i fr_CH -f UTF-8 fr_CH.UTF-8 && \
    localedef -c -i it_CH -f UTF-8 it_CH.UTF-8

USER 26

HEALTHCHECK --interval=30s --timeout=5s --start-period=60s CMD /usr/pgsql-11/bin/pg_isready -h localhost -p 5432
