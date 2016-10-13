-- name: injectable(name)
select * from users where '{{! name }}'

-- name: protection(name)
select * from users where '{{ name }}'