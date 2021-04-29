# 4章 3値論理
演習問題
1. NULLを含む場合のorder by
```sql
-- NULLは昇順の場合は一番最初、皇潤の場合は最後に来ました
select * from Students
order by age;
```

2. NULLと文字列の結合
```sql
-- NULLと結合した場合はNULLになりました(OK)
select
  concat(str, 'Hello') as greeting,
  description
from EmptyStr;
```

3. COALESCEとNULL IF
```sql
-- COALESCE = 最初に見つかったNULLでない値を返す
select
  name, coalesce(age, 0)
from Students;

-- NULLIF(expr1,expr2)
-- expr1 = expr2 が true の場合は NULL を返し、それ以外の場合は expr1 を返します。これは、CASE WHEN expr1 = expr2 THEN NULL ELSE expr1 END と同じです。
-- これ用途ある..?
```
