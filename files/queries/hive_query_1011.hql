use tiny_social;

SELECT to_date(b.send_time) AS Send_Time, b.message_text AS Message_Text,
length(b.message_text)/levenshtein('Nexus', b.message_text)
FROM chirpmessages a LATERAL VIEW json_tuple(a.line, 'chirpid','user','sender_location','send_time','referred_topics','message_text') b AS 
chirpid, user, sender_location, send_time, referred_topics, message_text 
WHERE length(b.message_text)/levenshtein('Nexus', b.message_text) > 1.128
ORDER BY Send_Time desc LIMIT 10;
