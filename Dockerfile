FROM mysql

ENV MYSQL_ROOT_PASSWORD=password
ENV MYSQL_DATABASE=tatsujin

# 日本語入力するための設定
# シーダーに日本語を入れると怒られるため
# RUN apt-get update \
#     && apt-get install -y locales \
#     && locale-gen ja_JP.UTF-8 \
#     && echo "export LANG=ja_JP.UTF-8" >> ~/.bashrc
RUN apt-get update && apt-get install -y locales
RUN sed -i -E 's/# (ja_JP.UTF-8)/\1/' /etc/locale.gen && locale-gen
ENV LANG ja_JP.UTF-8

WORKDIR /test