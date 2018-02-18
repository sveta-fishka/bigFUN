set hive.auto.convert.join=false;

use tiny_social;

SELECT  /*+ MAPJOIN(gu) */ gu.id as ID, gu.name as Name, count(gu.id) as COUNT_MESSAGES
FROM    (
	SELECT b.name, b.id
	FROM gleambookusers a 
	LATERAL VIEW json_tuple(a.line,'id','alias','name','user_since','friend_ids','employment') b AS 
	id, alias, name, user_since, friend_ids, employment
	WHERE to_date(b.user_since)>='2007-01-31'
	AND to_date(b.user_since)<='2009-01-31'
	) gu
JOIN 
	(
	SELECT d.message, d.author_id
	FROM gleambookmessages c 
	LATERAL VIEW json_tuple(c.line,'message_id','author_id','in_response_to','sender_location','send_time','message') d AS 
	message_id, author_id, in_response_to, sender_location, send_time, message
	WHERE to_date(d.send_time)>='2009-01-31'
	AND to_date(d.send_time)<='2010-01-31'	
	) gm
ON (gm.author_id = gu.id)
GROUP BY gu.id, gu.name;
