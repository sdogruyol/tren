-- name: escaped_users_without_parameters
select * from users where name = 'fatih "fka" akin' limit 1

-- name: escaped_users_without_parameters_2
select * from users where name = "hello" limit 1