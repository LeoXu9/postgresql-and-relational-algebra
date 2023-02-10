Loans join Returns:
select * from Loans inner join Returns on loan_id = loan;

Copies join above with equal copy_id:
select * from (select * from Loans inner join Returns on loan_id = loan) T1, Copies where copy_id = copy;


select author, title, count(*) as Num from (select * from (select * from Loans inner join Returns on loan_id = loan) T1, Copies where copy_id = copy)T2 group by author, title;

select author, title, avg(date-start) as Diff from (select * from (select * from Loans inner join Returns on loan_id = loan) T1, Copies where copy_id = copy)T2 group by author, title;

select author, title, count(*) as number_of_loans, round(avg(date-start)) as average_length_of_loans from (select * from (select * from Loans inner join Returns on loan_id = loan) T1, Copies where copy_id = copy)T2 group by author, title;

select author, title, count(*) as number_of_loans, cast((avg(date-start))as int) as average_length_of_loans from (select * from (select * from Loans inner join Returns on loan_id = loan) T1, Copies where copy_id = copy)T2 group by author, title;
