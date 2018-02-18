use tiny_social;

SELECT b.id as UserID, b.alias as Alias, b.name as Name,
b.user_since as User_since, b.friend_ids as Friends_IDs, 
b.employment as Employment
FROM gleambookusers a LATERAL VIEW json_tuple(a.line, 'id','alias','name','user_since','friend_ids','employment') b AS 
id, alias, name, user_since, friend_ids, employment
WHERE to_date(b.user_since)>='2007-01-31'
AND to_date(b.user_since)<='2009-01-31';
