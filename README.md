# Tren

Tren lets you use your SQL as a first class method in your Crystal code.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  tren:
    github: sdogruyol/tren
```

## Usage

Create a simple SQL file. The first line must be `-- name: your_method_name(args)`.

```sql
-- name: get_users(name : String, surname : String)

SELECT * FROM users WHERE name = '{{ name }}' AND surname = '{{ surname }}'
```

Require Tren and load your SQL file. It's going to create a first class method to your SQL.

```crystal
require "tren"

Tren.load("/path/to/your/file.sql")
```

### Overloading

```sql
-- name: get_users(name : String, surname : String)

SELECT * FROM users WHERE name = '{{ name }}' AND surname = '{{ surname }}'
```

```sql
-- name: get_users(name : String, age : Int32)

SELECT * FROM users WHERE name = '{{ name }}' AND age = {{ age }}
```

## Roadmap

  - Prevent SQL Injection.

## Contributing

1. Fork it ( https://github.com/sdogruyol/tren/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [f](https://github.com/f) Fatih Kadir Akın - creator, maintainer
- [sdogruyol](https://github.com/sdogruyol) Serdar Doğruyol - creator, maintainer

_Built on a TREN from Ankara to Istanbul._