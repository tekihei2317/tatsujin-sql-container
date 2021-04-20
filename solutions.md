### 1章 CASE式
本文
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

-- 賢いやり方
select
	std_id,
	case
		when count(*) = 1 then max(club_id)
		else max(case when main_club_flg = 'Y' then club_id else 0 end)
	end as main_club_id
from StudentClub
group by std_id;
```

演習問題
TODO

### 2章 ウインドウ関数
1. 各行について、過去の直近の日付を求める
```sql
select
	sample_date,
	min(sample_date) over (order by sample_date rows between 1 preceding and 1 preceding) as 'latest_date'
from LoadSample;

-- LAG関数
select
	sample_date,
	lag(sample_date, 1) over (order by sample_date) as 'latest_date'
from LoadSample;
```

2. 各行について、過去の直近の日付と、そのときの負荷を求める
```sql
select
	sample_date,
	load_val,
	min(sample_date) over (order by sample_date rows between 1 preceding and 1 preceding) as 'latest_date',
	 min(load_val) over (order by sample_date rows between 1 preceding and 1 preceding) as 'latest_load'
from LoadSample;

-- 名前付きウインドウで重複を削除
select
	sample_date,
	load_val,
	min(sample_date) over previous_row as 'latest_date',
	 min(load_val) over previous_row as 'latest_load'
from LoadSample
window previous_row as (order by sample_date rows between 1 preceding and 1 preceding);
```

3. 各行について、未来の直近の日付と、そのときの負荷を求める
```sql
select
	sample_date,
	load_val,
	min(sample_date) over next_row as 'next_date',
	 min(load_val) over next_row as 'next_load'
from LoadSample
window next_row as (order by sample_date rows between 1 following and 1 following);
```

演習問題
1. ウインドウ関数の結果予測1 
2. ウインドウ関数の結果予測2
```sql
-- パーティション = 全体
-- フレーム = パーティション全体(= 全体)
select
	server,
	load_val,
	sum(load_val) over () as sum_load
from ServerLoadSample;

-- パーティション = 全体
-- フレーム = パーティションの先頭から現在行まで
select
	server,
	load_val,
	sum(load_val) over (order by load_val) as sum_load
from ServerLoadSample;

-- パーティション = serverごと
-- フレーム　=  パーティション全体
select
	server,
	load_val,
	sum(load_val) over (partition by server) as sum_load
from ServerLoadSample;

-- パーティション = serverごと
-- フレーム　=  パーティション全体
select
	server,
	load_val,
	sum(load_val) over (partition by server order by load_val) as sum_load
from ServerLoadSample;
```
→ORDER BY句を使わなければ、フレームの範囲(集約関数の対象)がパーティション全体になるみたい  
(ORDER BY句を使ったときのみ、集約関数の対象がパーティションの先頭から現在行までになる)

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

# 5章 Exists