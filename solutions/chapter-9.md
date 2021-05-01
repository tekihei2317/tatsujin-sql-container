# 9章 集合演算
## 本文

<u>すべての技術に精通している人</u>

<details>
<summary>解答例(TODO)</summary>
<div>

```sql
TODO
```
</div>
</details>
<hr>

<u>等しい部分集合</u>
<details>
<summary>解答例</summary>
<div>

```sql
create view pairs as (
	select S1.sup as s1, S2.sup as s2
	from (select distinct sup from SupParts) S1
	cross join (select distinct sup from SupParts) S2
	where S1.sup < S2.sup
	order by S1.sup, S2.sup
);

select P.s1, P.s2
from pairs P
where
	-- 要素数が等しい
	(select count(*) from SupParts S where S.sup = s1) = 
	(select count(*) from SupParts S where S.sup = s2) and
	-- 和をとっても要素数が変わらない
	(select count(*) from SupParts S where S.sup = s1) =
	(select count(*)
		from (
			(select part from SupParts S where S.sup = s1) union
			(select part from SupParts S where S.sup = s2)
		) tmp
	);
```
</div>
</details>


## 演習問題
<u>UNIONだけを使うテーブルの比較</u>
<details>
<summary>解答例</summary>
<div>

```sql
-- |A| = |B| = |A ∪　B| <=> A = B
SELECT
	CASE
		WHEN
			COUNT(*) = (SELECT COUNT(*) FROM Tbl_A) AND
			COUNT(*) = (SELECT COUNT(*) FROM Tbl_B)
			THEN '等しい'
		ELSE '異なる'
	END
FROM (
	SELECT * FROM Tbl_A UNION
	SELECT * FROM Tbl_B
) TMP;
```
</div>
</details>
<hr>

<u>すべての技術に精通している人2(過不足なし)</u>

<details>
<summary>解答例(TODO)</summary>
<div>

```sql
TODO
```
</div>
</details>
<hr>