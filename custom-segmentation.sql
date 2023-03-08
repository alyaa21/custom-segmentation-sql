
select e4.customer_id,Recency,Frequancy,Monetay,r_score,fm_score,
CASE 
WHEN (R_Score = 4) AND (Fm_Score  =5 )
THEN 'Champions'
WHEN (R_Score = 5) AND (Fm_Score  =5 or FM_SCORE=4 )
THEN 'Champions'
WHEN (R_SCORE  = 5) AND (FM_SCORE =2) 
THEN 'Potential Loyalists'
WHEN (R_SCORE = 4) AND (FM_SCORE=2 or FM_SCORE= 3) 
THEN 'Potential Loyalists'
WHEN (R_SCORE  = 3) AND (FM_SCORE =3) 
THEN 'Potential Loyalists'
WHEN (R_SCORE  = 5) AND (FM_SCORE =3) 
THEN 'Loyal Customers'
WHEN (R_SCORE  = 4) AND (FM_SCORE =4) 
THEN 'Loyal Customers'
WHEN (R_SCORE  = 3) AND (FM_SCORE =5) 
THEN 'Loyal Customers'
WHEN (R_SCORE  = 3) AND (FM_SCORE =4) 
THEN 'Loyal Customers'
WHEN (R_SCORE  = 5) AND (FM_SCORE =1) 
THEN 'Recent Customers'
WHEN (R_SCORE  = 4 or R_SCORE  = 3) AND (FM_SCORE =1) 
THEN 'Promising'
WHEN (R_SCORE  = 3 or R_SCORE  = 2) AND (FM_SCORE =2) 
THEN 'Customers Needing Attention'
WHEN (R_SCORE  = 2) AND (FM_SCORE =3) 
THEN 'Customers Needing Attention'
WHEN (R_SCORE  = 2) AND (FM_SCORE =5 or FM_SCORE =4 or FM_SCORE =1) 
THEN 'At Risk'
WHEN (R_SCORE  = 1) AND (FM_SCORE =3) 
THEN 'At Risk'
WHEN (R_SCORE  = 1) AND (FM_SCORE =4 or FM_SCORE =5) 
THEN 'Cant Lose Them'
WHEN (R_SCORE  = 1) AND (FM_SCORE =1) 
THEN 'Lost'
WHEN (R_SCORE  = 1) AND (FM_SCORE =2) 
THEN 'Hibernating'
END AS cust_segment
from(
select e3.* ,ntile(5)over(order by fm_ ) fm_score
from(
select e2.*, ntile(5) over (order by recency desc) r_score, round( (Frequancy+ Monetay )/2,0) fm_  from
( 
select e.customer_id , ceil(abs(to_date('09/12/2011','dd/mm/yyyy') - datee)) Recency,e.Frequancy, round(e.Monetayy/1000,2) Monetay from (
select distinct customer_id,max(TO_DATE(invoicedate, 'mm/dd/yyyy HH24:MI')) over(partition by customer_id) datee, count(distinct invoice) over(partition by customer_id) as Frequancy,
sum(price*quantity) over(partition by customer_id) Monetayy
from tableretail
order by customer_id) e
)e2)e3)e4;