FROM crunchydata/crunchy-postgres-gis:centos8-13.3-3.1-4.6.3

USER root

RUN cd /etc/yum.repos.d/ && \
    sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* && \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
RUN yum -y --disablerepo=crunchypg13 install glibc-locale-source \
    && yum -y clean all
RUN localedef -c -i de_CH -f UTF-8 de_CH.UTF-8 && \
    localedef -c -i fr_CH -f UTF-8 fr_CH.UTF-8 && \
    localedef -c -i it_CH -f UTF-8 it_CH.UTF-8

USER 26

HEALTHCHECK --interval=30s --timeout=5s --start-period=60s CMD /usr/pgsql-13/bin/pg_isready -h localhost -p 5432
