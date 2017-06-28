FROM debian:jessie 

ENV PERCONA_VERSION 5.7
ENV DBPASS root

RUN groupadd -r mysql && useradd -r -g mysql -u 1001 -r -g 0 -s /sbin/nologin \
    -c "Default Application User" mysql
    
RUN apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A && \
    echo "deb http://repo.percona.com/apt jessie main" >> /etc/apt/sources.list

RUN apt-get update 
RUN DBPASS="root"
RUN echo "percona-server-server-5.6 percona-server-server/root_password password root" | debconf-set-selections
RUN echo "percona-server-server-5.6 percona-server-server/root_password_again password root" | debconf-set-selections
# thank obama
RUN apt-get install -qq -y --allow-unauthenticated wget percona-server-server-5.6 # bouuuhhh c'est moche

VOLUME ["/var/lib/mysql", "/var/log/mysql"]

RUN chmod 777 -R /var/lib/mysql

RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64
RUN chmod +x /usr/local/bin/dumb-init

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
CMD ["mysqld"]
