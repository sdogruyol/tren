-- name: multiline_one(name : String)
select * from users
where name = '{{name}}'

-- name: multiline_two(name : String)
select * from users
where name = '{{name}}'