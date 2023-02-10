join Books, Copies and Loans (100 rows):

select BC.title, BC.author, BC.genre, BC.subgenre, BC.copy_id, BC.branch, L.customer from
(select B.title, B.author, B.genre, B.subgenre, C.copy_id, C.branch from Books B join Copies C on B.title = C.title AND B.author = C.author) BC
join
Loans L
on BC.copy_id = L.copy;


group by genres and subgenres:

select BCL.genre, BCL.subgenre, count(distinct customer) as Num 
from (select BC.title, BC.author, BC.genre, BC.subgenre, BC.copy_id, BC.branch, L.customer from
(select B.title, B.author, B.genre, B.subgenre, C.copy_id, C.branch from Books B join Copies C on B.title = C.title AND B.author = C.author) BC
join
Loans L
on BC.copy_id = L.copy) BCL
group by genre, subgenre;


find aficionados:
select BCL.customer, count(distinct concat(genre, subgenre)) as Num
from (select BC.title, BC.author, BC.genre, BC.subgenre, BC.copy_id, BC.branch, L.customer from
(select B.title, B.author, B.genre, B.subgenre, C.copy_id, C.branch from Books B join Copies C on B.title = C.title AND B.author = C.author) BC
join
Loans L
on BC.copy_id = L.copy) BCL
group by BCL.customer;


select customers that are aficionados:
select *
from (
select BCL.customer, count(distinct concat(genre, subgenre)) as Num
from (select BC.title, BC.author, BC.genre, BC.subgenre, BC.copy_id, BC.branch, L.customer from
(select B.title, B.author, B.genre, B.subgenre, C.copy_id, C.branch from Books B join Copies C on B.title = C.title AND B.author = C.author) BC
join
Loans L
on BC.copy_id = L.copy) BCL
group by BCL.customer
) CustomerNum
where num=1;


join above with BCLprojected:


select afi1.num, afi1.customer, BCL.subgenre, BCL.genre from
(
select *
from (
select BCL.customer, count(distinct concat(genre, subgenre)) as Num
from (select BC.title, BC.author, BC.genre, BC.subgenre, BC.copy_id, BC.branch, L.customer from
(select B.title, B.author, B.genre, B.subgenre, C.copy_id, C.branch from Books B join Copies C on B.title = C.title AND B.author = C.author) BC
join
Loans L
on BC.copy_id = L.copy) BCL
group by BCL.customer
) CustomerNum
where num=1 
) afi1
join
(
select BC.title, BC.author, BC.genre, BC.subgenre, BC.copy_id, BC.branch, L.customer from
(select B.title, B.author, B.genre, B.subgenre, C.copy_id, C.branch from Books B join Copies C on B.title = C.title AND B.author = C.author) BC
join
Loans L
on BC.copy_id = L.copy
)BCL
on afi1.customer = BCL.customer;


count the customers for above:


select count(distinct customer) as Num, afi2.genre, afi2.subgenre
from
(
select afi1.num, afi1.customer, BCL.subgenre, BCL.genre from
(
select *
from (
select BCL.customer, count(distinct concat(genre, subgenre)) as Num
from (select BC.title, BC.author, BC.genre, BC.subgenre, BC.copy_id, BC.branch, L.customer from
(select B.title, B.author, B.genre, B.subgenre, C.copy_id, C.branch from Books B join Copies C on B.title = C.title AND B.author = C.author) BC
join
Loans L
on BC.copy_id = L.copy) BCL
group by BCL.customer
) CustomerNum
where num=1 
) afi1
join
(
select BC.title, BC.author, BC.genre, BC.subgenre, BC.copy_id, BC.branch, L.customer from
(select B.title, B.author, B.genre, B.subgenre, C.copy_id, C.branch from Books B join Copies C on B.title = C.title AND B.author = C.author) BC
join
Loans L
on BC.copy_id = L.copy
)BCL
on afi1.customer = BCL.customer
) afi2
group by genre, subgenre;



First three columns:
((select BCL.genre, BCL.subgenre, count(distinct customer) as Num 
from (select BC.title, BC.author, BC.genre, BC.subgenre, BC.copy_id, BC.branch, L.customer from
(select B.title, B.author, B.genre, B.subgenre, C.copy_id, C.branch from Books B join Copies C on B.title = C.title AND B.author = C.author) BC
join
Loans L
on BC.copy_id = L.copy) BCL
group by genre, subgenre)

UNION
select Bks.genre, Bks.subgenre, 0 as Num from Books Bks where not CONCAT(Bks.genre, Bks.subgenre) in 

(select concat(BCL1.genre, BCL1.subgenre) from

(select BCL.genre, BCL.subgenre, count(distinct customer) as Num 
from (select BC.title, BC.author, BC.genre, BC.subgenre, BC.copy_id, BC.branch, L.customer from
(select B.title, B.author, B.genre, B.subgenre, C.copy_id, C.branch from Books B join Copies C on B.title = C.title AND B.author = C.author) BC
join
Loans L
on BC.copy_id = L.copy) BCL
group by genre, subgenre)BCL1
));



1,2,4th columns:
(
(select afi2.genre, afi2.subgenre,count(distinct customer) as Num
from
(
select afi1.num, afi1.customer, BCL.subgenre, BCL.genre from
(
select *
from (
select BCL.customer, count(distinct concat(genre, subgenre)) as Num
from (select BC.title, BC.author, BC.genre, BC.subgenre, BC.copy_id, BC.branch, L.customer from
(select B.title, B.author, B.genre, B.subgenre, C.copy_id, C.branch from Books B join Copies C on B.title = C.title AND B.author = C.author) BC
join
Loans L
on BC.copy_id = L.copy) BCL
group by BCL.customer
) CustomerNum
where num=1 
) afi1
join
(
select BC.title, BC.author, BC.genre, BC.subgenre, BC.copy_id, BC.branch, L.customer from
(select B.title, B.author, B.genre, B.subgenre, C.copy_id, C.branch from Books B join Copies C on B.title = C.title AND B.author = C.author) BC
join
Loans L
on BC.copy_id = L.copy
)BCL
on afi1.customer = BCL.customer
) afi2
group by genre, subgenre)

UNION

select Bks.genre, Bks.subgenre, 0 as Num from Books Bks where not CONCAT(Bks.genre, Bks.subgenre) in 

(select concat(ASDF.genre, ASDF.subgenre) from
(select count(distinct customer) as Num, afi2.genre, afi2.subgenre
from
(
select afi1.num, afi1.customer, BCL.subgenre, BCL.genre from
(
select *
from (
select BCL.customer, count(distinct concat(genre, subgenre)) as Num
from (select BC.title, BC.author, BC.genre, BC.subgenre, BC.copy_id, BC.branch, L.customer from
(select B.title, B.author, B.genre, B.subgenre, C.copy_id, C.branch from Books B join Copies C on B.title = C.title AND B.author = C.author) BC
join
Loans L
on BC.copy_id = L.copy) BCL
group by BCL.customer
) CustomerNum
where num=1 
) afi1
join
(
select BC.title, BC.author, BC.genre, BC.subgenre, BC.copy_id, BC.branch, L.customer from
(select B.title, B.author, B.genre, B.subgenre, C.copy_id, C.branch from Books B join Copies C on B.title = C.title AND B.author = C.author) BC
join
Loans L
on BC.copy_id = L.copy
)BCL
on afi1.customer = BCL.customer
) afi2
group by genre, subgenre) ASDF
)
);






Answer:
select T1.genre, T1.subgenre, T1.num, T2.num from
((select BCL.genre, BCL.subgenre, count(distinct customer) as Num 
from (select BC.title, BC.author, BC.genre, BC.subgenre, BC.copy_id, BC.branch, L.customer from
(select B.title, B.author, B.genre, B.subgenre, C.copy_id, C.branch from Books B join Copies C on B.title = C.title AND B.author = C.author) BC
join
Loans L
on BC.copy_id = L.copy) BCL
group by genre, subgenre)

UNION
select Bks.genre, Bks.subgenre, 0 as Num from Books Bks where not CONCAT(Bks.genre, Bks.subgenre) in 

(select concat(BCL1.genre, BCL1.subgenre) from

(select BCL.genre, BCL.subgenre, count(distinct customer) as Num 
from (select BC.title, BC.author, BC.genre, BC.subgenre, BC.copy_id, BC.branch, L.customer from
(select B.title, B.author, B.genre, B.subgenre, C.copy_id, C.branch from Books B join Copies C on B.title = C.title AND B.author = C.author) BC
join
Loans L
on BC.copy_id = L.copy) BCL
group by genre, subgenre)BCL1
))T1

INNER JOIN

(
(select afi2.genre, afi2.subgenre,count(distinct customer) as Num
from
(
select afi1.num, afi1.customer, BCL.subgenre, BCL.genre from
(
select *
from (
select BCL.customer, count(distinct concat(genre, subgenre)) as Num
from (select BC.title, BC.author, BC.genre, BC.subgenre, BC.copy_id, BC.branch, L.customer from
(select B.title, B.author, B.genre, B.subgenre, C.copy_id, C.branch from Books B join Copies C on B.title = C.title AND B.author = C.author) BC
join
Loans L
on BC.copy_id = L.copy) BCL
group by BCL.customer
) CustomerNum
where num=1 
) afi1
join
(
select BC.title, BC.author, BC.genre, BC.subgenre, BC.copy_id, BC.branch, L.customer from
(select B.title, B.author, B.genre, B.subgenre, C.copy_id, C.branch from Books B join Copies C on B.title = C.title AND B.author = C.author) BC
join
Loans L
on BC.copy_id = L.copy
)BCL
on afi1.customer = BCL.customer
) afi2
group by genre, subgenre)

UNION

select Bks.genre, Bks.subgenre, 0 as Num from Books Bks where not CONCAT(Bks.genre, Bks.subgenre) in 

(select concat(ASDF.genre, ASDF.subgenre) from
(select count(distinct customer) as Num, afi2.genre, afi2.subgenre
from
(
select afi1.num, afi1.customer, BCL.subgenre, BCL.genre from
(
select *
from (
select BCL.customer, count(distinct concat(genre, subgenre)) as Num
from (select BC.title, BC.author, BC.genre, BC.subgenre, BC.copy_id, BC.branch, L.customer from
(select B.title, B.author, B.genre, B.subgenre, C.copy_id, C.branch from Books B join Copies C on B.title = C.title AND B.author = C.author) BC
join
Loans L
on BC.copy_id = L.copy) BCL
group by BCL.customer
) CustomerNum
where num=1 
) afi1
join
(
select BC.title, BC.author, BC.genre, BC.subgenre, BC.copy_id, BC.branch, L.customer from
(select B.title, B.author, B.genre, B.subgenre, C.copy_id, C.branch from Books B join Copies C on B.title = C.title AND B.author = C.author) BC
join
Loans L
on BC.copy_id = L.copy
)BCL
on afi1.customer = BCL.customer
) afi2
group by genre, subgenre) ASDF
)
)T2

on((T1.genre=T2.genre)AND(T1.subgenre=T2.subgenre));
