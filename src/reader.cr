require "./parser"

Dir.glob(ARGV[0]).each do |file|
  lines = File.read_lines(file)
  Parser.new(lines).parse
end