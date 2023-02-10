Loans joins Returns:

select * from Loans L join Returns R on R.loan = L.loan_id;


find the customers where at least one return date is before start:

select * from
(select * from Loans L join Returns R on R.loan = L.loan_id) LR1
inner join
(select * from Loans L join Returns R on R.loan = L.loan_id) LR2
on ((LR2.start > LR1.date) and (LR1.customer=LR2.customer));


slim the above down:

select LR.customer from
(select * from Loans L join Returns R on R.loan = L.loan_id) LR
join
(select * from Loans L join Returns R on R.loan = L.loan_id) LR2
on LR.customer = LR2.customer
and LR.date<LR2.start;


minus the above ineligible customers:

select * from (Loans L join Returns R on R.loan = L.loan_id) LR1
where not LR1.customer in (
    select LR.customer from
(select * from Loans L join Returns R on R.loan = L.loan_id) LR
join
(select * from Loans L join Returns R on R.loan = L.loan_id) LR2
on LR.customer = LR2.customer
and LR.date<LR2.start
);


SELECT customer,max(start) FROM
(
select * from (Loans L join Returns R on R.loan = L.loan_id) LR1
where not LR1.customer in (
    select LR.customer from
(select * from Loans L join Returns R on R.loan = L.loan_id) LR
join
(select * from Loans L join Returns R on R.loan = L.loan_id) LR2
on LR.customer = LR2.customer
and LR.date<LR2.start
)
) C
GROUP BY customer
order by customer;


