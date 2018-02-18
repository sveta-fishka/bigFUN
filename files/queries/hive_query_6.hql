use tiny_social;

SELECT AVG(LENGTH(b.message_text)) as Avg_Length
FROM chirpmessages a LATERAL VIEW json_tuple(a.line, 'chirpid','user','sender_location','send_time','referred_topics','message_text') b AS 
chirpid, user, sender_location, send_time, referred_topics, message_text 
WHERE to_date(b.send_time) >= '2006-01-01'
AND to_date(b.send_time) < '2008-01-01';
