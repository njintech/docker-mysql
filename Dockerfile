FROM ubuntu.user.base

ENV MYSQL_USER=mysql \
    MYSQL_DATA_DIR=/var/lib/mysql \
    MYSQL_RUN_DIR=/run/mysqld \
    MYSQL_LOG_DIR=/var/log/mysql

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server curl tzdata \
 && rm -rf ${MYSQL_DATA_DIR} \
 && rm -rf /var/lib/apt/lists/*

RUN echo "Asia/Seoul" > /etc/timezone
RUN rm /etc/localtime
RUN dpkg-reconfigure -f noninteractive tzdata

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

RUN sed -i 's/bind/#bind/' /etc/mysql/mysql.conf.d/mysqld.cnf

EXPOSE 3306/tcp
VOLUME ["${MYSQL_DATA_DIR}", "${MYSQL_RUN_DIR}"]
ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["/usr/bin/mysqld_safe"]
