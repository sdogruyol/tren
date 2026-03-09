## 2.0.0 - 09-03-2026

- GitHub Actions CI workflow to run format checks and specs on push and pull requests.
- New parser test suite for metadata parsing, SQL line detection, and placeholder interpolation.
- New utils test suite for `Tren.escape` edge cases (quotes, backslashes, unicode, non-string values).
- Parser errors now include source file and line for malformed metadata/placeholders.
- `Tren.escape_character = "\\'"` now applies PostgreSQL-style quote doubling (`'` -> `''`) for string values. Fixes [#12](https://github.com/sdogruyol/tren/issues/12)

## 1.0.0 - 26-03-2021

- Crystal 1.0.0 support.

## 0.3.0 - 29-10-2016

- Query escaping by default.
- `Tren.escape_character =` to set a custom escape character.

## 0.2.0 - 12-10-2016

- Multiline SQL query support.
- Multiple SQL queries per file support.
- Proper double quote escaping.
- Glob support to load multiple files at once.
- SQL injection escaping.
- Composable SQL queries.