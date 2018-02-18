add jar
  ${env:HOME}/Desktop/test/gis-tools-hadoop-2.0.jar;  
	create temporary function ST_Point as 'com.esri.hadoop.hive.ST_Point';
	create temporary function ST_Distance as 'com.esri.hadoop.hive.ST_Distance';
	create temporary function st_astext as 'com.esri.hadoop.hive.ST_AsText';
	create temporary function st_x as 'com.esri.hadoop.hive.ST_X';
	create temporary function st_y as 'com.esri.hadoop.hive.ST_Y';

use tiny_social;

SELECT p.user_name, p.text, ST_Distance(ST_Point(cast(p.local_point_x as float),cast(p.local_point_y as float)),ST_Point(37.9787,72.1714)) as DISTANCE  
FROM 
	(SELECT substr(b.sender_location, 1, instr(b.sender_location,',')-1) as local_point_x,
	substr(b.sender_location, instr(b.sender_location,',')+1, length(b.sender_location)-1) as local_point_y,
	c.screen_name as user_name, b.message_text as text
	FROM chirpmessages a LATERAL VIEW json_tuple(a.line, 'chirpid','sender_location','send_time','referred_topics','message_text','user') b AS 
	chirpid, sender_location, send_time, referred_topics, message_text, user LATERAL VIEW json_tuple(b.user, 'screen_name', 'lang', 'friends_count', 'statuses_count', 'name', 'followers_count') c 
	AS screen_name, lang, friends_count, statuses_count, name, followers_count
WHERE to_date(b.send_time) >= '2006-01-01'
AND to_date(b.send_time) < '2009-01-01'
) p
WHERE ST_Distance(ST_Point(cast(p.local_point_x as float),cast(p.local_point_y as float)),ST_Point(37.9787,72.1714)) <= 4
ORDER BY DISTANCE desc 
LIMIT 10; 

