def isMeta(line)
  line.match(/^\s*-- name: ([a-z\_\?\!]+?\(.*?\)).*?\n/)
end

def isComment(line)
  line.match(/^\s*--.*/)
end

def parse(lines)
  lines.reject {|x| isComment(x) && !isMeta(x) || x == "\n"}
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
lines.each_slice(2) do |meta_and_sql|
  meta = get_metadata(meta_and_sql[0])
  sql = parse_sql(meta_and_sql[1])

  puts "def #{meta}"
  puts "\"#{sql.strip}\""
  puts "end"
  puts "\n"
end
