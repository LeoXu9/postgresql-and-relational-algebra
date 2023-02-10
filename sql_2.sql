Loans join Returns:
select L.* from Returns R left join Loans L on (L.loan_id = R.loan);

the loans that have not been returned (right):
select * from Loans except (select L.* from Returns R join Loans L on (L.loan_id = R.loan));

1...customer + active loans(okok):
select t1.customer, count(*) as Num from (select * from Loans except (select L.* from Returns R join Loans L on L.loan_id = R.loan)) T1 group by customer;

1.5...:
select C.cust_id, 0 as Num from Customers C where not exists (select t1.customer from (select * from Loans except (select L.* from Returns R join Loans L on L.loan_id = R.loan)) T1 group by customer);

1.51...(okok):
select C.cust_id, 0 as Num from Customers C where not C.cust_id in (select t1.customer from (select * from Loans except (select L.* from Returns R join Loans L on L.loan_id = R.loan)) T1 group by customer);

the loans that have been returned on time:
select * from Returns R join Loans L on L.loan_id = R.loan where date<=due;

2...customer + on time returns:
select t4.customer, count(*) as Num from (select * from Returns R join Loans L on L.loan_id = R.loan where date<=due)T4  group by customer;

2.5...:
select C.cust_id, 0 as Num from Customers C where not C.cust_id in (select t5.customer from (select * from Returns R join Loans L on L.loan_id = R.loan where date<=due)T5 group by customer);


3...customer + late returns:
select t3.customer, count(*) as Num from (select * from Returns R join Loans L on L.loan_id = R.loan where date>due)T3  group by customer;

3.5...:
select C.cust_id, 0 as Num from Customers C where not C.cust_id in (select t7.customer from (select * from Returns R join Loans L on L.loan_id = R.loan where date>due)T7  group by customer);

ok join:
select T3.customer, T3.num, T6.num
from
(
select T1.customer, count(*) as Num from (select * from Loans except (select L.* from Returns R join Loans L on L.loan_id = R.loan)) T1 group by customer
UNION
select C.cust_id, 0 as Num from Customers C where not C.cust_id in (select T2.customer from (select * from Loans except (select L.* from Returns R join Loans L on L.loan_id = R.loan)) T2 group by customer)
)T3
INNER JOIN
(
select t4.customer, count(*) as Num from (select * from Returns R join Loans L on L.loan_id = R.loan where date<=due)T4  group by customer
UNION
select C.cust_id, 0 as Num from Customers C where not C.cust_id in (select t5.customer from (select * from Returns R join Loans L on L.loan_id = R.loan where date<=due)T5 group by customer)
)T6
on T3.customer = T6.customer;


Answer:
select T3.customer, T3.num, T6.num, T9.num
from
(
select T1.customer, count(*) as Num from (select * from Loans except (select L.* from Returns R join Loans L on L.loan_id = R.loan)) T1 group by customer
UNION
select C.cust_id, 0 as Num from Customers C where not C.cust_id in (select T2.customer from (select * from Loans except (select L.* from Returns R join Loans L on L.loan_id = R.loan)) T2 group by customer)
)T3
INNER JOIN
(
select t4.customer, count(*) as Num from (select * from Returns R join Loans L on L.loan_id = R.loan where date<=due)T4  group by customer
UNION
select C.cust_id, 0 as Num from Customers C where not C.cust_id in (select t5.customer from (select * from Returns R join Loans L on L.loan_id = R.loan where date<=due)T5 group by customer)
)T6
on T3.customer = T6.customer
INNER JOIN
(
select t7.customer, count(*) as Num from (select * from Returns R join Loans L on L.loan_id = R.loan where date>due)T7  group by customer
UNION
select C.cust_id, 0 as Num from Customers C where not C.cust_id in (select t8.customer from (select * from Returns R join Loans L on L.loan_id = R.loan where date>due)T8  group by customer)
)T9
on T6.customer=T9.customer;
