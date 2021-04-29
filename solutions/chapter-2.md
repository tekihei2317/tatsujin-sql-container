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