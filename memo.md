### まずはコマンドでやってみる

バックグラウンドでMySQLコンテナを起動して、その中に入ります。
```
# 最後のmysqlがイメージ名で、間はオプションです
# Usage:  docker run [OPTIONS] IMAGE [COMMAND] [ARG...]
# MYSQL_ROOT_PASSWORDを渡さないと怒られます
docker run -e MYSQL_ROOT_PASSWORD=password --name mysql_container -d mysql

# 起動の確認
docker container ls

# コンテナの中に入る(パスワードは設定したもの=passwordを入力します)
# Usage:  docker exec [OPTIONS] CONTAINER COMMAND [ARG...]
docker exec -it mysql_container mysql -u root -p
```

### Dockerfileを使ってやってみる

DockerfileからDockerイメージを作ります
```Dockerfile
FROM mysql

ENV MYSQL_ROOT_PASSWORD=password
```
```bash
# Usage:  docker build [OPTIONS] PATH | URL | -
# -tで生成するイメージにタグをつけられます(名前みたいなもの?)
docker build -t mysql_image .

# イメージからコンテナを生成します
# パスワードはDockerfileで定義すると、イメージを作ったときに埋め込まれるようです
docker run --name=mysql_container -d mysql_image

# コンテナの中に入ります
docker exec -it mysql_container mysql -u root -p

# ↓docker runでコンテナに入ろうとすると上手くいきませんでした
# ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/var/run/mysqld/mysqld.sock' (2)
docker run -it mysql_image mysql -u root -p
```

### SQLクライアントからつなげるようにする
Sequel Aceでつなげるようにします
ポートフォワーディングの設定を追加するとできました
```Dockerfile
FROM mysql

ENV MYSQL_ROOT_PASSWORD=password
```
```
docker build -t mysql_image . && \
docker run --name=mysql_container -d -p 3306:3306 mysql_image

docker exec -it mysql_container mysql -u root -p
```

### docker-composeを使ってみる
```yaml
version: '3.8'

services:
  # 公式のイメージから作成
  db:
    image: mysql
    ports:
      - 3306:3306
    environment:
      MYSQL_ROOT_PASSWORD: password
      MYSQL_DATABASE: tatsujin
  # 自作のDockerfileから作成
  db2:
    build:
      context: .
      dockerfile: ./Dockerfile
    ports:
      - 3307:3307
```
```bash
# 起動
docker-compose up -d

# ターミナルからコンテナに入る場合
docker-compose exec db mysql -u root -p
```
気になること
- docker-composeファイルの変更を読み込むためにはdocker-compose up -dを実行すれば良い？
  - 環境変数を変更したのですが、反映されませんでいした
  - docker-compose up -d --buildでも反映されませんでした
  - downしてからupすると反映されていました。一回コンテナを削除(停止?)しないといけないかもです

### データベースに初期データを投入する
コンテナ内の/docker-entrypoint-initdb.dにクエリを書いたファイル(拡張子sql/sh/sql.gz)を置くと、実行してくれるみたいです。
initdb.dというディレクトリを作って、そこにmysqldumpで作ったファイルを置いておきました。
```yaml
version: '3.8'

services:
  # 公式のイメージから作成
  db:
    image: mysql
    ports:
      - 3306:3306
    volumes:
      - ./initdb.d:/docker-entrypoint-initdb.d
    environment:
      MYSQL_ROOT_PASSWORD: password
      MYSQL_DATABASE: tatsujin
  # 自作のDockerfileから作成
  db2:
    build:
      context: .
      dockerfile: ./Dockerfile
    ports:
      - 3307:3307
    volumes:
      - ./initdb.d:/docker-entrypoint-initdb.d
```