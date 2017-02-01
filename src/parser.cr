class Parser
  LINE_RE      = /^\s*--\s*name:\s*([a-z\_\?\!0-9]+)(\(.*?\)|).*?$/
  PARAM_RE     = /\{\{(.*?)\}\}/
  PARAM_RAW_RE = /\{\{\!(.*?)\}\}/

  @metadata = ""
  @sql_lines = [] of String

  def initialize(@lines : Array(String))
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
        define_method(@metadata, @sql_lines.each.join("\\n"))
        @sql_lines.clear
      end
    end
  end

  # checks if the given line contains metadata
  # example: -- name: get_users(name, surname)
  def metadata?(line)
    line.chomp.match(LINE_RE)
  end

  # checks for lines that is neither comment line (starts with -- )
  # nor whitespace
  def sql?(line)
    line.match(/^(?!\s*--)/) && line.match(/\S/)
  end

  def get_metadata(meta)
    meta.gsub(LINE_RE) do |token, match|
      "#{match[1]}#{match[2]}"
    end
  end

  def parse_sql(sql)
    sql = sql.gsub(PARAM_RAW_RE) do |token, match|
      "\#{#{match[1]}}"
    end
    sql = sql.gsub(PARAM_RE) do |token, match|
      "\#{Tren.escape(#{match[1]})}"
    end
  end

  def set_indent(sql)
    sql.lines.map do |line|
      "  #{line}"
    end.join("").strip
  end

  def define_method(metadata, sql)
    method = <<-METHOD
    def #{metadata}
      <<-SQL
      #{set_indent(sql)}
      SQL
    end
    METHOD
    puts "#{method}"
  end
end
