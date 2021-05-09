# 10章 数列
## 本文
### Problem - 地方ごとの人口の合計

県名と人口のテーブル（PopTbl）が与えられます。四国地方と、九州地方と、その他の地方の人口を求めてください。

**テーブル定義**

```sql
CREATE TABLE PopTbl (
  pref_name VARCHAR(32) PRIMARY KEY,
  population INTEGER NOT NULL
);
```

**入力(PopTbl)**

| pref_name | population |
|:-:|-:|
| 佐賀      |        100 |
| 徳島      |        100 |
| 愛媛      |        150 |
| 東京      |        400 |
| 福岡      |        300 |
| 群馬      |         50 |
| 長崎      |        200 |
| 香川      |        200 |
| 高知      |        200 |

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

**出力**
| district  | population |
|:-:|-:|
| 九州      |        600 |
| 四国      |        650 |
| その他    |        450 |

<details>
<summary>解答例</summary>

```sql
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
入力(PopTbl2)

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