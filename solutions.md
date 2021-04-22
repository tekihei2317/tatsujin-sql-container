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