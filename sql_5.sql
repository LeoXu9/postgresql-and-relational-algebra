1.find the loans that have not been returned:

select *, '9999-12-31' as date from Loans L where L.loan_id not in (select loan from Returns);


2.find the ones that have been returned:

select * from Loans L join Returns R on R.loan = L.loan_id order by customer;


3.join loan and return for returned records and unreturned records:

select * from (
(select *, '9999-12-31' as date from Loans L where L.loan_id not in (select loan from Returns))
UNION
(select loan_id, copy, customer, start, due, date from Loans L join Returns R on R.loan = L.loan_id)
) LR0
order by customer;


4. find the loans with at least one that does not overlap based on same customer number:
select * from
(
select * from (
(select *, '9999-12-31' as date from Loans L where L.loan_id not in (select loan from Returns)) 
UNION
(select loan_id, copy, customer, start, due, date from Loans L join Returns R on R.loan = L.loan_id)
) LR1
)LR5
where not exists
(
select * from 
(
select * from (
(select *, '9999-12-31' as date from Loans L where L.loan_id not in (select loan from Returns))
UNION
(select loan_id, copy, customer, start, due, date from Loans L join Returns R on R.loan = L.loan_id)
) LR2
)LR6
where LR5.customer = LR6.customer and
LR5.start < LR6.date and
LR5.date > LR6.start and
(LR5.start <> LR6.start or LR5.date <> LR6.date)
)
order by customer;



5.deal with 32 (2 loans with same start and date):
select * from
(
select * from (
(select *, '9999-12-31' as date from Loans L where L.loan_id not in (select loan from Returns)) 
UNION
(select loan_id, copy, customer, start, due, date from Loans L join Returns R on R.loan = L.loan_id)
) LR1
)LR5
where not exists
(
select * from 
(
select * from (
(select *, '9999-12-31' as date from Loans L where L.loan_id not in (select loan from Returns))
UNION
(select loan_id, copy, customer, start, due, date from Loans L join Returns R on R.loan = L.loan_id)
) LR2
)LR6
where LR5.customer = LR6.customer and
LR5.start < LR6.date and
LR5.date > LR6.start and
((LR5.start <> LR6.start or LR5.date <> LR6.date) or (LR5.loan_id <> LR6.loan_id))
)
order by customer;








select L.customer, max(L.start) from Loans L
where not customer in
(select customer from (

select * from
(
select * from (
(select *, '9999-12-31' as date from Loans L where L.loan_id not in (select loan from Returns)) 
UNION
(select loan_id, copy, customer, start, due, date from Loans L join Returns R on R.loan = L.loan_id)
) LR1
)LR5
where not exists
(
select * from 
(
select * from (
(select *, '9999-12-31' as date from Loans L where L.loan_id not in (select loan from Returns))
UNION
(select loan_id, copy, customer, start, due, date from Loans L join Returns R on R.loan = L.loan_id)
) LR2
)LR6
where LR5.customer = LR6.customer and
LR5.start < LR6.date and
LR5.date > LR6.start and
((LR5.start <> LR6.start or LR5.date <> LR6.date) or (LR5.loan_id <> LR6.loan_id))
)
order by customer

)A2)
group by customer
order by customer;