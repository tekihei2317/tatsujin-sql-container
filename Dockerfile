FROM mysql

ENV MYSQL_ROOT_PASSWORD=password
ENV MYSQL_DATABASE=tatsujin

WORKDIR /test