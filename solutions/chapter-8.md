# 8章 外部結合
演習
1. 中間ビューの排除
```sql
-- TODO
```
2. 子供の数
```sql
-- 子供のいない人表示するように気をつける
select employee, count(*) - 1
from (
  select employee, 'dummy_child' as child_name
  from Personnel

  union all
  select employee, child_1 as child_name
  from Personnel
  where child_1 is not null

  union all
  select employee, child_2 as child_name
  from Personnel
  where child_2 is not null

  union all
  select employee, child_3 as child_name
  from Personnel
  where child_3 is not null
) children
group by employee;

-- 解答例(OUTER JOINでNULLの行を残す)
drop view if exists children;

create view children as (
	select child_1 as child_name
	from Personnel
	where child_1 is not null

	union
	select child_2 as child_name
	from Personnel
	where child_2 is not null

	union
	select child_3 as child_name
	from Personnel
	where child_3 is not null
);

select P.employee, count(C.child_name)
from Personnel P
left outer join children C
on
	P.child_1 = C.child_name or
	P.child_2 = C.child_name or
	P.child_3 = C.child_name
group by P.employee;
```

3. MERGE文(UPSERT)
MySQLはMERGE文がないため、UPDATEとINSERTを使うか、UPSERTする
```sql
-- 前処理
update Class_B set name = '内海' 
where id = 2;

-- 1. UPDATEとINSERT
start transaction;

update Class_A
set name = coalesce(
	(select name from Class_B where Class_A.id = Class_B.id), Class_A.name
);

insert into Class_A
select *
from Class_B
where not exists(
	select * from Class_A where Class_B.id = Class_A.id
);

select * from Class_A;
rollback;

-- 2. UPSERT
start transaction;

insert into Class_A
select * from Class_B
on duplicate key update name = (select name from Class_B where Class_B.id = Class_A.id);

select * from Class_A;
rollback;
```