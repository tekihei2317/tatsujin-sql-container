# tatsujin-sql-container

達人に学ぶSQL徹底指南書のデータ入りのMySQLコンテナです。データは[サポートページ](https://www.shoeisha.co.jp/book/download/9784798157825/detail)からお借りしました。

## 環境構築

```bash
docker-compose up -d --build
```
## 接続情報

|host|port|username|password|
|-|-|-|-|
|localhost|3306|root|password|


## 使用方法

章ごとにデータベースが分かれています(Chapter1~Chapter10)。各データベースには、その章で使用するテーブルが入っています。

また、/problems配下には、各章で登場する問題を演習形式で解けるようにまとめてあるので、ご活用ください(現在対応中です)。

クエリを書くのはVSCodeに[MySQLの拡張機能](https://marketplace.visualstudio.com/items?itemName=cweijan.vscode-mysql-client2)を入れて使うのがおすすめです。
