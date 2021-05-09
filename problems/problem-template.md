### Problem - 問題名

ここに問題文を入れる

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
-- INSErT文を入れる
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
-- ここに解答を入れる
```
</details>