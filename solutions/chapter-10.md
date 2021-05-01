# 10章 数列
## 本文
### Problem - 0~999までの数列をビューで作る

<details>
<summary>解答例</summary>
<div>

```sql
create VIEW Sequence(seq) as (
  select D1.digit + D2.digit * 10 + D3.digit * 100 as seq
  from Digits D1
  cross join Digits D2
  cross join Digits D3
  order by seq
);
```
</div>
</details>
<hr>

### Problem - 欠番をすべて求める
<details>
<summary>解答例</summary>
<div>

```sql
select seq
from Sequence
cross join (select min(seq) as min_value from SeqTbl) as MinTable
cross join (select max(seq) as max_value from SeqTbl) as MaxTable
where
  min_value <= seq and seq <= max_value
  and seq not in (select seq from SeqTbl)
order by seq;
```
</div>
</details>
<hr>

### Problem - 3人で並んで座れる座席を求める
<details>
<summary>解答例</summary>
<div>

```sql
-- 開始地点から3つの席がすべて空
select
  seat as start_seat
  , seat + 2 as end_seat
from Seats S1
where (
  select count(*)
  from Seats S2
  where
    S1.seat <= S2.seat
    and S2.seat <= S1.seat + 2
    and S2.status = '空'
) = 3;
```
</div>
</details>

<details>
<summary>解答例(NOT EXISTS)</summary>
<div>

```sql
select
  seat as start_seat
  , seat + 2 as end_seat
from Seats S1
where
  -- 3つ席を確保できる
  S1.seat + 2 <= (select max(seat) from Seats)
  -- 3つすべて空席
  and not exists (
    select *
    from Seats S2
    where
      S1.seat <= S2.seat
      and S2.seat <= S1.seat + 2
      and S2.status = '占'
  );
```
</div>
</details>
<hr>

### Problem - 3人で並んで座れる座席を求める(折り返しあり)
<details>
<summary>解答例</summary>
<div>

```sql
-- 開始地点から見て、同じ列に空席が3個続いている
select
  seat as start_seat
  , seat + 2 as end_seat
from Seats2 S1
where (
  select count(*)
  from Seats2 S2
  where
    S1.seat <= S2.seat
    and S2.seat <= S1.seat + 2
    and S1.line_id = S2.line_id
    and S2.status = '空'
) = 3
```
</div>
</details>
<hr>

### Problem - 単調増加と単調減少(TODO)
<details>
<summary>解答例</summary>
<div>

```sql
TODO
```
</div>
</details>
<hr>

## 演習問題

↓テンプレート
### Problem - 問題名
<details>
<summary>解答例</summary>
<div>

```sql
TODO
```
</div>
</details>
<hr>