



# 3章 自己結合
1. 順序対
```sql
select P1.name, P2.name
from Products P1
inner join Products P2 on P1.name != P2.name;
```
2. 非順序対
```sql
-- 昇順ソートして自分より右を選ぶイメージ
select P1.name, P2.name
from Products P1
inner join Products P2
on P1.name < P2.name;
```
3. 3つの組み合わせの場合
```sql
-- 手続き型の3重ループと似ている(JOINはループ！)
select P1.name, P2.name, P3.name
from Products P1
inner join Products P2 on P1.name < P2.name
inner join Products P3 on P2.name < P3.name;
```
4. 重複行の削除
同じグループの中で、IDが一番小さいもの以外を消去する(where句でサブクエリを使う)

演習問題
1. 重複組合せ
```sql
select P1.name, P2.name
from Products P1
join Products P2
on P1.name <= P2.name;
```

2. 重複行の削除
```sql
-- 元のテーブルは変更していないです
create table ProductsWithRowNumber
select
  row_number() over (partition by name, price) as row_num,
  name,
  price
from Products2;

select * from ProductsWithRowNumber;
delete from ProductsWithRowNumber where row_num > 1;
select * from ProductsWithRowNumber;
```
