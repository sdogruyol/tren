-- name: get_users_info(name : String, age1 : Int32, age2 : Int32)
select * from users 
where name = '{{name}}' 
    and age BETWEEN {{age1}} and {{age2}}
