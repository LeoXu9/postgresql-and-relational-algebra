select T1.branch, T2.Num, cast(cast(T1.Num as float)/cast(T2.Num as float)as int) as result
from
(select branch, count(*) as Num from Copies group by branch) T1
join
(select branch, count(distinct concat(author, title)) as Num from Copies group by branch) T2
on T1.branch=T2.branch;