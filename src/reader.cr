def remove_comments(sql)
  sql = sql.lines[1..-1].join "\n"
  sql.gsub(/^\s*--.*?\n/, "").strip
end

def get_metadata(sql)
  sql.lines[0].gsub(/^\s*-- name: ([a-z\_\?\!]+?\(.*?\)).*?\n/) do |token, match|
    match[1]
  end
end

def parse(sql)
  sql = remove_comments(sql)
  sql.gsub(/\{\{(.*?)\}\}/) do |token, match|
    "\#{#{match[1]}}"
  end
end

sql = File.read(ARGV[0])
meta = get_metadata(sql)
puts "def #{meta}"
puts "\"#{parse(sql).strip}\""
puts "end"
