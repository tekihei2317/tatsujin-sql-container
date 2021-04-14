### 1章 CASE式
1. 地方ごとの人口の合計を求める
2. 人口階級ごとの都道府県の数を求める
3. それぞれの県について、男性と女性の人口を一行にまとめる
4. 条件法をCASE式で表現する(未理解)
5. 条件付きのUpdate
```sql
-- TODO: 初期データにまだ戻す方法を考える(今はトランザクションをRollbackしてます)
update Salaries set salary = case
	when salary >= 300000 then salary * 0.9
	when 250000 <= salary and salary < 280000 then salary * 1.2
	else salary
end;

```
6. 主キーの入れ替え
```sql
-- TODO: 模範解答でエラーが出るので原因を調べる
-- エラーが出ます(Duplicate entry 'b' for key 'SomeTable.PRIMARY')
update SomeTable set p_key = case
	when p_key = 'a' then 'b'
	when p_key = 'b' then 'a'
	else p_key
end;
```

7. ある月にある講座が開講しているかの表を作る
```sql
drop function if exists to_symbol;
create function to_symbol(flag boolean) returns varchar(1) deterministic
return case
	when flag then 'o'
	else 'x'
end;

select
	course_name,
	to_symbol(course_id in (select course_id from OpenCourses where month = 201806)) as '6月',
	to_symbol(course_id in (select course_id from OpenCourses where month = 201807)) as '7月',
	to_symbol(course_id in (select course_id from OpenCourses where month = 201808)) as '8月'
from CourseMaster;
```

8. 生徒のメインの部活を求める
```sql
-- 普通のやり方
select * 
from (
	select
		std_id, max(club_id) as main_club_id
	from StudentClub
	group by std_id
	having count(*) = 1

	union
	select
		std_id, max(case when main_club_flg = 'Y' then club_id else 0 end) as main_club_id
	from StudentClub
	group by std_id
	having count(*) > 1
	) as students
order by main_club_id;

--賢いやり方
select
	std_id,
	case
		when count(*) = 1 then max(club_id)
		else max(case when main_club_flg = 'Y' then club_id else 0 end)
	end as main_club_id
from StudentClub
group by std_id;
```
