use tiny_social;

SELECT NAME, EMPLOYMENT
FROM
	(
	SELECT b.name as Name, b.employment as Employment, 
		sum(cast(emp_rec like '%start_date%' as int)) as sum_start, 
		sum(cast(emp_rec like '%end_date%' as int)) as sum_end
	FROM gleambookusers a LATERAL VIEW json_tuple(a.line, 'id','alias','name','user_since','friend_ids','employment') 	  b AS id, alias, name, user_since, friend_ids, 
	employment LATERAL VIEW explode(split(substr(b.employment,1,length(b.employment) - 2),'},')) exploded_table as 		emp_rec
		WHERE to_date(b.user_since) >= '2007-02-05'
		AND to_date(b.user_since) < '2015-02-05'
	GROUP BY b.name, b.employment
	) emp_tbl
WHERE emp_tbl.sum_start > emp_tbl.sum_end;

