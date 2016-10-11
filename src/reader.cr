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
  merged_lines = [] of String
  last_was_sql = false
  lines.each do |line|
    if is_metadata(line)
      merged_lines << line.strip
      last_was_sql = false
    elsif is_sql(line)
      if last_was_sql
        last_element = merged_lines.pop
        merged_lines << last_element + " " + line.strip
      else
        merged_lines << line.strip
      end
      last_was_sql = true
    end
  end
  merged_lines
end

def get_metadata(meta)
  meta.gsub(/^\s*-- name: ([a-z\_\?\!]+?\(.*?\)).*?/) do |token, match|
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
  sql = parse_sql(metadata_and_sql[1]).strip

  puts "def #{metadata}"
  puts "\"#{sql}\""
  puts "end"
  puts "\n"

  heredoc = <<-SQL
  #{sql}
  SQL

  method = <<-METHOD
  def #{metadata}
    "#{heredoc}"
  end
  METHOD

  puts "#{method}"
end
