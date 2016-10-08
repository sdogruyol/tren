-- name: get_users(name : String, age : Int32)
select * from users where name = '{{name}}' and age = {{age}}