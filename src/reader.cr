# checks if the given line contains metadata
# example: -- name: get_users(name, surname)
def is_metadata(line)
  line.match(/^\s*-- name: ([a-z\_\?\!]+?\(.*?\)).*?\n/)
end

# checks for lines that is neither comment line (starts with -- )
# nor whitespace
def is_sql(line)
  line.match(/^(?!\s*--)/) && line.match(/\S/)
end

def parse(lines)
  lines.select {|line| is_metadata(line) || is_sql(line)}
end

def get_metadata(meta)
  meta.gsub(/^\s*-- name: ([a-z\_\?\!]+?\(.*?\)).*?\n/) do |token, match|
    match[1]
  end
end

def parse_sql(sql)
  sql.gsub(/\{\{(.*?)\}\}/) do |token, match|
    "\#{#{match[1]}}"
  end
end

lines = File.read_lines(ARGV[0])
lines = parse(lines)
lines.each_slice(2) do |metadata_and_sql|
  metadata = get_metadata(metadata_and_sql[0])
  sql = parse_sql(metadata_and_sql[1])

  puts "def #{metadata}"
  puts "\"#{sql.strip}\""
  puts "end"
  puts "\n"
end
