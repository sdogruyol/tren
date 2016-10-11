class Parser
  @metadata = ""
  @sql_lines = [] of String

  def initialize
    @lines = File.read_lines(ARGV[0])
    @metadata_index = 0
  end

  def parse
    @lines.each_with_index do |line, index|
      if metadata?(line)
        @metadata_index = index
        @metadata = get_metadata(line)
        @lines.each_with_index do |sql_line, sql_line_index|
          next if sql_line_index <= @metadata_index.as(Int32)
          break if metadata?(sql_line)
          if sql?(sql_line)
            sql = parse_sql(sql_line).strip
            @sql_lines << sql
          end
        end
        define_method(@metadata, @sql_lines.each.join("\n"))
        @sql_lines.clear
      end
    end
  end

  # checks if the given line contains metadata
  # example: -- name: get_users(name, surname)
  def metadata?(line)
    line.match(/^\s*-- name: ([a-z\_\?\!]+?\(.*?\)).*?\n/)
  end

  # checks for lines that is neither comment line (starts with -- )
  # nor whitespace
  def sql?(line)
    line.match(/^(?!\s*--)/) && line.match(/\S/)
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

  def define_method(metadata, sql)
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
end
