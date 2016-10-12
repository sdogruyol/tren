-- name: composition_1

where name = "fatih"

-- name: composition_2

select * from users {{ composition_1 }}