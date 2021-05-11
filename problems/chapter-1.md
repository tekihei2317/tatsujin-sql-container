# 1章 CASE式
## 本文
### Problem - 地方ごとの人口の合計

県名と人口のテーブル（PopTbl）が与えられます。各地方の人口の合計を、四国地方、九州地方、その他の地方の3つに分けて求めてください。

**テーブル定義**

```sql
CREATE TABLE PopTbl (
  pref_name VARCHAR(32) PRIMARY KEY,
  population INTEGER NOT NULL
);
```

**入出力例**

<details>
<summary>INSERT文</summary>

```sql
INSERT INTO PopTbl VALUES ('徳島', 100);
INSERT INTO PopTbl VALUES ('香川', 200);
INSERT INTO PopTbl VALUES ('愛媛', 150);
INSERT INTO PopTbl VALUES ('高知', 200);
INSERT INTO PopTbl VALUES ('福岡', 300);
INSERT INTO PopTbl VALUES ('佐賀', 100);
INSERT INTO PopTbl VALUES ('長崎', 200);
INSERT INTO PopTbl VALUES ('東京', 400);
INSERT INTO PopTbl VALUES ('群馬', 50);
```
</details>

```
入力

PopTbl
+-----------+------------+
| pref_name | population |
+-----------+------------+
| 佐賀      |        100 |
| 徳島      |        100 |
| 愛媛      |        150 |
| 東京      |        400 |
| 福岡      |        300 |
| 群馬      |         50 |
| 長崎      |        200 |
| 香川      |        200 |
| 高知      |        200 |
+-----------+------------+

出力

+-----------+------------+
| district  | population |
+-----------+------------+
| 九州      |        600 |
| 四国      |        650 |
| その他    |        450 |
+-----------+------------+
```

<details>
<summary>解答例</summary>

```sql
-- 実行順はgroup by → selectだが、MySQLやPostgreSQLはselect句の列の計算を先に行っているため、問題なく実行できる
select
  case
      when pref_name in ('徳島', '愛媛', '香川', '高知') then '四国'
      when pref_name in ('福岡', '佐賀', '長崎') then '九州'
      else 'その他'
  end as district
  , sum(population) as population
from PopTbl
group by district
;
```
</details>


### Problem - 異なる条件の集計

ある県の男性または女性の人口を表すレコードが入ったテーブル（PopTbl2）が与えられます。性別は1が男性、2が女性とします。以下の例のように、各県の男性と女性の人口を一行にまとめてください。

**テーブル定義**

```sql
CREATE TABLE PopTbl2 (
  pref_name VARCHAR(32),
  sex CHAR(1) NOT NULL,
  population INTEGER NOT NULL,
  PRIMARY KEY(pref_name, sex)
);
```

**入出力例**

<details>
<summary>INSERT文</summary>

```sql
INSERT INTO PopTbl2 VALUES ('徳島', '1', 60);
INSERT INTO PopTbl2 VALUES ('徳島', '2', 40);
INSERT INTO PopTbl2 VALUES ('香川', '1', 100);
INSERT INTO PopTbl2 VALUES ('香川', '2', 100);
INSERT INTO PopTbl2 VALUES ('愛媛', '1', 100);
INSERT INTO PopTbl2 VALUES ('愛媛', '2', 50);
INSERT INTO PopTbl2 VALUES ('高知', '1', 100);
INSERT INTO PopTbl2 VALUES ('高知', '2', 100);
INSERT INTO PopTbl2 VALUES ('福岡', '1', 100);
INSERT INTO PopTbl2 VALUES ('福岡', '2', 200);
INSERT INTO PopTbl2 VALUES ('佐賀', '1', 20);
INSERT INTO PopTbl2 VALUES ('佐賀', '2', 80);
INSERT INTO PopTbl2 VALUES ('長崎', '1', 125);
INSERT INTO PopTbl2 VALUES ('長崎', '2', 125);
INSERT INTO PopTbl2 VALUES ('東京', '1', 250);
INSERT INTO PopTbl2 VALUES ('東京', '2', 150);
```
</details>

```
入力

PopTbl2
+-----------+-----+------------+
| pref_name | sex | population |
+-----------+-----+------------+
| 佐賀      | 1   |         20 |
| 佐賀      | 2   |         80 |
| 徳島      | 1   |         60 |
| 徳島      | 2   |         40 |
| 愛媛      | 1   |        100 |
| 愛媛      | 2   |         50 |
| 東京      | 1   |        250 |
| 東京      | 2   |        150 |
| 福岡      | 1   |        100 |
| 福岡      | 2   |        200 |
| 長崎      | 1   |        125 |
| 長崎      | 2   |        125 |
| 香川      | 1   |        100 |
| 香川      | 2   |        100 |
| 高知      | 1   |        100 |
| 高知      | 2   |        100 |
+-----------+-----+------------+

出力

+-----------+-----------------+-------------------+
| pref_name | male_population | female_population |
+-----------+-----------------+-------------------+
| 佐賀      |              20 |                80 |
| 徳島      |              60 |                40 |
| 愛媛      |             100 |                50 |
| 東京      |             250 |               150 |
| 福岡      |             100 |               200 |
| 長崎      |             125 |               125 |
| 香川      |             100 |               100 |
| 高知      |             100 |               100 |
+-----------+-----------------+-------------------+
```

<details>
<summary>解答例</summary>

```sql
select
  pref_name
  , sum(case when sex = 1 then population else 0 end) as male_population
  , sum(case when sex = 2 then population else 0 end) as female_population
from PopTbl2
group by pref_name
;
```
</details>

### Problem - テーブル同士のマッチング

講座を表すテーブル（CourseMaster）と、開講している講座を表すテーブル（OpenCourses）が与えられます。以下の例のように、ある講座が何月に開講しているかが分かるような表を作成してください。

**テーブル定義**

```sql
CREATE TABLE CourseMaster (
  course_id INTEGER PRIMARY KEY,
  course_name VARCHAR(32) NOT NULL
);

CREATE TABLE OpenCourses (
  month INTEGER,
  course_id INTEGER,
  PRIMARY KEY(month, course_id)
);
```

**入出力例**

<details>
<summary>INSERT文</summary>

```sql
INSERT INTO CourseMaster VALUES (1, '経理入門');
INSERT INTO CourseMaster VALUES (2, '財務知識');
INSERT INTO CourseMaster VALUES (3, '簿記検定');
INSERT INTO CourseMaster VALUES (4, '税理士');

INSERT INTO OpenCourses VALUES (201806, 1);
INSERT INTO OpenCourses VALUES (201806, 3);
INSERT INTO OpenCourses VALUES (201806, 4);
INSERT INTO OpenCourses VALUES (201807, 4);
INSERT INTO OpenCourses VALUES (201808, 2);
INSERT INTO OpenCourses VALUES (201808, 4);
```
</details>

```
入力

CourseMaster
+-----------+--------------+
| course_id | course_name  |
+-----------+--------------+
|         1 | 経理入門     |
|         2 | 財務知識     |
|         3 | 簿記検定     |
|         4 | 税理士       |
+-----------+--------------+

OpenCourses
+--------+-----------+
| month  | course_id |
+--------+-----------+
| 201806 |         1 |
| 201806 |         3 |
| 201806 |         4 |
| 201807 |         4 |
| 201808 |         2 |
| 201808 |         4 |
+--------+-----------+

出力

+--------------+------+------+------+
| course_name  | 6月  | 7月  | 8月  |
+--------------+------+------+------+
| 経理入門     | o    | x    | x    |
| 財務知識     | x    | x    | o    |
| 簿記検定     | o    | x    | x    |
| 税理士       | o    | o    | o    |
+--------------+------+------+------+

```

<details>
<summary>解答例</summary>

```sql
-- IN述語
select
  CM.course_name
  , case
    when CM.course_id in (select course_id from OpenCourses where month = 201806)
      then 'o'
    else 'x'
  end as '6月'
  , case
    when CM.course_id in (select course_id from OpenCourses where month = 201807)
      then 'o'
    else 'x'
  end as '7月'
  , case
    when CM.course_id in (select course_id from OpenCourses where month = 201808)
      then 'o'
    else 'x'
  end as '8月'
from CourseMaster CM
;

-- EXISTS述語
select
  CM.course_name
  , case
    when
      exists (
        select * from OpenCourses OC where OC.month = 201806 and OC.course_id = CM.course_id
      ) then 'o'
    else 'x'
  end as '6月'
  , case
    when
      exists (
        select * from OpenCourses OC where OC.month = 201807 and OC.course_id = CM.course_id
      ) then 'o'
    else 'x'
  end as '7月'
  , case
    when
      exists (
        select * from OpenCourses OC where OC.month = 201808 and OC.course_id = CM.course_id
      ) then 'o'
    else 'x'
  end as '8月'
from CourseMaster CM
;
```
</details>

### Problem - メインの部活

生徒が所属する部活を表すテーブル（StudentClub）が与えられます。複数の部活に入っている生徒もおり、メインの部活を表すフラグ列にはYまたはNの値が入っています。このテーブルから、次の条件でクエリを発行してください。

- 1つだけの部活に所属している生徒については、そのクラブIDを取得する
- 複数のクラブをかけ持ちしている生徒については、メインの部活のIDを取得する

**テーブル定義**

```sql
CREATE TABLE StudentClub (
  std_id INTEGER,
  club_id INTEGER,
  club_name VARCHAR(32),
  main_club_flg CHAR(1),
  PRIMARY KEY (std_id, club_id)
);
```

**入出力例**

<details>
<summary>INSERT文</summary>

```sql
INSERT INTO StudentClub VALUES (100, 1, '野球', 'Y');
INSERT INTO StudentClub VALUES (100, 2, '吹奏楽', 'N');
INSERT INTO StudentClub VALUES (200, 2, '吹奏楽', 'N');
INSERT INTO StudentClub VALUES (200, 3, 'バドミントン', 'Y');
INSERT INTO StudentClub VALUES (200, 4, 'サッカー', 'N');
INSERT INTO StudentClub VALUES (300, 4, 'サッカー', 'N');
INSERT INTO StudentClub VALUES (400, 5, '水泳', 'N');
INSERT INTO StudentClub VALUES (500, 6, '囲碁', 'N');
```
</details>

```
入力

StudentClub
+--------+---------+--------------------+---------------+
| std_id | club_id | club_name          | main_club_flg |
+--------+---------+--------------------+---------------+
|    100 |       1 | 野球               | Y             |
|    100 |       2 | 吹奏楽             | N             |
|    200 |       2 | 吹奏楽             | N             |
|    200 |       3 | バドミントン       | Y             |
|    200 |       4 | サッカー           | N             |
|    300 |       4 | サッカー           | N             |
|    400 |       5 | 水泳               | N             |
|    500 |       6 | 囲碁               | N             |
+--------+---------+--------------------+---------------+

出力

+--------+--------------+
| std_id | main_club_id |
+--------+--------------+
|    100 |            1 |
|    200 |            3 |
|    300 |            4 |
|    400 |            5 |
|    500 |            6 |
+--------+--------------+
```

<details>
<summary>解答例</summary>

```sql
-- 解答例1. 2回クエリを発行する
select
  std_id
  , max(case when main_club_flg = 'Y' then club_id else null end)
from StudentClub
group by std_id
having count(*) > 1
union all
select
  std_id
  , max(club_id)
from StudentClub
group by std_id
having count(*) = 1
;

-- 解答例2. HAVING句ではなく、SELECT句で条件分岐する
select
  std_id
  , case
    when count(*) = 1 then max(club_id)
    else max(case when main_club_flg = 'Y' then club_id else null end)
  end as main_club_id
from StudentClub
group by std_id
;

-- 解答例3. 他の列の値もしたい場合は、WINDOW関数を使うと良さそう
select
  std_id
  , club_id
from (
  select
    *
    , count(*) over (partition by std_id) as club_count
  from StudentClub
) as StudentClub
where main_club_flg = 'Y' or club_count = 1
;
```
</details>