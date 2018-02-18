use tiny_social;

SELECT c.screen_name as Name, AVG(LENGTH(b.message_text)) as Avg_Length
FROM chirpmessages a LATERAL VIEW json_tuple(a.line, 'chirpid','sender_location','send_time','referred_topics','message_text','user') b AS 
chirpid, sender_location, send_time, referred_topics, message_text, user LATERAL VIEW json_tuple(b.user, 'screen_name', 'lang', 'friends_count', 'statuses_count', 'name', 'followers_count') c 
AS screen_name, lang, friends_count, statuses_count, name, followers_count  
WHERE to_date(b.send_time) >= '2006-01-01'
AND to_date(b.send_time) < '2008-01-01'
GROUP BY c.screen_name
ORDER BY Avg_Length desc 
LIMIT 10;
