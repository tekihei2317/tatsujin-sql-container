# 5章 Exists
本文

1. それぞれの回について、出席していない人物を求める
```sql
with all_combinations as (
  select * 
  from (select distinct meeting from Meetings) m
  cross join (select distinct person from Meetings) p
  order by meeting
)

-- こう書きたいけど、MySQLはEXCEPTをサポートしていないので、エラーになる
select * from all_combinations
except
select * from Meetings;

-- NOT EXISTSを使う
select * from all_combinations as T1
where not exists (
  select * from Meetings as T2
  where T1.meeting = T2.meeting and T1.person = T2.person
);
```

2. すべての教科について50点以上
```
```

3. 算数の点数が80点以上かつ、国語の点数が50点以上
```sql
-- 算数が80点未満ではない かつ 国語が50点未満ではない
with students as (
  select distinct student_id from TestScores
)

select * from students S
where
  not exists (
    select * from TestScores T
    where T.student_id = S.student_id and T.subject = '算数' and T.score < 80
  )
  and
  not exists (
    select * from TestScores T
    where T.student_id = S.student_id and T.subject = '国語' and T.score < 50
  )
```
```sql
-- 書籍の解答
with students as (
  select distinct student_id from TestScores
)

select * from students S
where not exists (
  select * from TestScores T
  where
    T.student_id = S.student_id and
    T.subject in ('算数', '国語') and
    T.score < case when
      T.subject = '算数' then 80
      else 50
    end
);
```

4. 算数の点数が80点以上かつ、国語の点数が50点以上(どちらの教科も存在しないと駄目)
```sql
-- これでいい気がします
select student_id
from TestScores
where
  subject = '算数' and score >= 80 or
  subject = '国語' and score >=50
group by student_id
having count(*) = 2;
```

5. ちょうど1番の工程まで終わっているプロジェクトを求める
```sql
-- 全部0番から始まって、歯抜けがなく、順番に完了するならこれでOK
select project_id
from Projects
group by project_id
having sum(status = '完了') = 2;
```
```sql
-- 1番目までは全部完了で、それ以降は全部待機
-- これは歯抜けがあっても大丈夫
select project_id
from Projects
group by project_id
having count(*) = sum (
  step_nbr <= 1 and status = '完了' or 
  step_nbr > 1 and status = '待機'
);
```
```sql
-- 1番目以下で待機、または2番目以降で完了のものが存在しない
select project_id
from (select distinct project_id from Projects) P1
where not exists (
  select * from Projects P2
  where
    P1.project_id = P2.project_id and
    (
      step_nbr <= 1 and status = '待機' or
      step_nbr > 1 and status = '完了'
    )
);

select project_id
from (select distinct project_id from Projects) P1
where not exists (
  select * from Projects P2
  where
    P1.project_id = P2.project_id and
    P2.status != (case when P2.step_nbr <=1 then '完了' else '待機' end) -- 2重否定になっている！
);
```
6. 列に対する量化量化
MySQLはALL/ANYの引数がサブクエリだったので、できなかったです。

演習問題
1. 値がすべて1のエンティティを取得する(行持ち)
```sql
-- EXISTS(x)
-- 以下だとすべてNULLの'A'も選ばれた
-- 理由: すべてNULLの場合、whereの結果がunknownになって、1行も選択されないため
select distinct key1
from ArrayTbl2 A1
where not exists (
  select * from ArrayTbl2 A2
  where
    A1.key1 = A2.key1 and 
    A2.val != 1
);

-- EXISTS(o)
select distinct key1
from ArrayTbl2 A1
where not exists (
  select * from ArrayTbl2 A2
  where
    A1.key1 = A2.key1 and 
    (A2.val is null or A2.val != 1)
);

-- HAVING句
select key1
from ArrayTbl2
group by key1
having count(*) = count(val = 1);
```
2. ちょうど1番の工程まで終わっているプロジェクトを求める(ALLを使う)
```sql
select distinct project_id
from Projects P1
where
  '完了' = all(
    select status from Projects P2
    where P1.project_id = P2.project_id and P2.step_nbr <= 1
  ) and
  '待機' = all(
    select status from Projects P2
    where P1.project_id = P2.project_id and P2.step_nbr > 1
  );
-- 解答例
select distinct project_id
from Projects P1
where 'o' = ALL(
  select
    case
      when P2.step_nbr <= 1 and P2.status = '完了' then 'o'
      when P2.step_nbr > 1 and P2.status = '待機' then 'o'
      else 'x'
    end
  from Projects P2
  where P1.project_id = P2.project_id
);

-- これでもいいかな？
-- 1のところ0と'o'にしたら同じ結果が帰ってきたのだけれど、'o'って0と同じ扱い?
select distinct project_id
from Projects P1
where 1 = ALL(
  select
    P2.step_nbr <= 1 and P2.status = '完了' or 
    P2.step_nbr > 1 and P2.status = '待機'
  from Projects P2
  where P1.project_id = P2.project_id
);
```
3. 1から100までの素数を列挙する
```sql
-- 素数:=1と自身以外に約数を持たない(1は除く)
create table numbers (
	with digits(number) as (
	  select 0 union all
	  select 1 union all
	  select 2 union all
	  select 3 union all
	  select 4 union all
	  select 5 union all
	  select 6 union all
	  select 7 union all
	  select 8 union all
	  select 9
	)

	select D1.number + D2.number * 10 as number
	from digits D1, digits D2
	where D1.number + D2.number > 1
	order by number
);

select * from numbers N1
where not exists (
  select * from numbers N2
  where
    N2.number < N1.number and N1.number mod N2.number = 0
);
```
```sql
-- 再帰with(よく分かってない)
with recursive numbers(number) as (
  select 2
  union all

  select number + 1
  from numbers
  where number + 1 < 100
)

select * from numbers N1
where not exists (
  select * from numbers N2
  where
    N2.number < N1.number and N1.number mod N2.number = 0
);
```
