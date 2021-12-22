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

クエリを書くのはVSCodeに[MySQLの拡張機能](https://marketplace.visualstudio.com/items?itemName=cweijan.vscode-mysql-client2)を入れて使うのがおすすめです。

## 問題一覧

| 章  | 問題                                                  | 難易度 |
| --- | ----------------------------------------------------- | ------ |
| 1   | [地方ごとの人口の合計](./problems/chapter-1/1.md)     | ☆☆   |
| 1   | [異なる条件の集計](./problems/chapter-1/2.md)         | ☆☆   |
| 1   | [テーブル同士のマッチング](./problems/chapter-1/3.md) | ☆☆   |
| 1   | [メインの部活](./problems/chapter-1/4.md)             | ☆☆☆ |
| 2   | [商品の価格の移動平均](./problems/chapter-2/1.md)     | ☆☆   |
| 2   | [サーバーの負荷の分析](./problems/chapter-2/2.md)     | ☆☆   |
