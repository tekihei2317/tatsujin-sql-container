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
### Problem - 欠番をすべて求める(NOT EXISTSまたは外部結合を使う)
<details>
<summary>解答例(NOT EXISTS)</summary>
<div>

```sql
select seq
from Sequence
where
  seq >= (select min(seq) from SeqTbl)
  and seq <= (select max(seq) from SeqTbl)
  and not exists (
    select * from SeqTbl
    where SeqTbl.seq = Sequence.seq
  );
```
</div>
</details>

<details>
<summary>解答例(外部結合)</summary>
<div>

```sql
select S1.seq
from Sequence S1
left outer join SeqTbl S2
on S1.seq = S2.seq
where
  S1.seq >= (select min(seq) from SeqTbl)
  and S1.seq <= (select max(seq) from SeqTbl)
  and S2.seq is null
-- 順番が入れ替わっていたため並べ替え
order by seq;
```
</div>
</details>
<hr>

### Problem - 3人で並んで座れる座席を求める(HAVING句を使う)
<details>
<summary>解答例</summary>
<div>

```sql
-- 始点と、始点から終点までに含まれる席の組み合わせを作ってから、始点で集約する
select
  S1.seat as start_seat
  , S1.seat + 2 as end_seat
from Seats S1, Seats S2
where
  S1.seat <= S2.seat
  and S2.seat <= S1.seat + 2
group by S1.seat
-- キャストしたほうが良い？
having sum(S2.status = '空') = 3;
```
</div>
</details>
<hr>
