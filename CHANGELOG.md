# v0.3.0 (29-10-2016)

- Escape queries by default.
- Add `Tren.escape_character = ` to specify your custom escape character.
    
        Tren.escape_character = "\\'" # For Postgresql

# v0.2.0 (12-10-2016)

- Support multiline SQL queries.
- Support multiple SQL queries in a single file.
- Properly escape double quotes.
- Add glob support to load multiple files at once.
- Escape SQL injections.
- Composable SQL queries <3