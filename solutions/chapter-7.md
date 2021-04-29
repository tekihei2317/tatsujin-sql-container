# 7章 ウィンドウ関数
演習
1. 移動平均をサブクエリで求める
```sql
select
  prc_date,
  (
    select
      avg(prc_amt)
    from Accounts A2
    where
       (select count(*) from Accounts A3 where A3.prc_date between A2.prc_date and A1.prc_date)
       between 1 and 3
  ) as average_amount
from Accounts A1;
```

2. 移動平均を求める(3行未満はNULLにする)
```sql
-- ウインドウ関数
select
  prc_date,
  case
    when row_num < 3 then null
    else average_amount
  end as average_amount
from(
  select
    prc_date,
    prc_amt,
  row_number() over (order by prc_date) as row_num,
  avg(prc_amt) over (order by prc_date rows 2 preceding) as average_amount
  from Accounts A1
) AccountsWithAverage;
```
