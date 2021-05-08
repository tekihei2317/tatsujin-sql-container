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

<details>
<summary>INSERT文</summary>

```sql
CREATE TABLE PopTbl (
  pref_name VARCHAR(32) PRIMARY KEY,
  population INTEGER NOT NULL
);

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

**出力**
| district  | population |
|:-:|-:|
| 九州      |        600 |
| 四国      |        650 |
| その他    |        450 |

<details>
<summary>解答例</summary>
<div>

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
</div>
</details>

### Problem - 地方ごとの人口の合計

県名と人口のテーブルが与えられます。四国地方と、九州地方と、その他の地方の人口を求めてください。

**入力**
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

出力
| district  | population |
|:-:|-:|
| 九州      |        600 |
| 四国      |        650 |
| その他    |        450 |

<details>
<summary>解答例</summary>
<div>

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
</div>
</details>


