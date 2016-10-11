-- name: multiline(name : String)
select * from users
where name = '{{name}}'
limit 1