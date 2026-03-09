class Parser
  LINE_RE      = /^\s*--\s*name:\s*([a-z\_\?\!0-9]+)(\(.*?\)|).*?$/
  NAME_HINT_RE = /^\s*--\s*name\b/
  PARAM_RE     = /\{\{(.*?)\}\}/
  PARAM_RAW_RE = /\{\{\!(.*?)\}\}/

  class ParseError < Exception
  end

  @metadata = ""
  @sql_lines = [] of String

  def initialize(@lines : Array(String), @source : String = "(unknown)")
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
          if malformed_metadata_hint?(sql_line)
            raise_parse_error(
              "invalid metadata format, expected `-- name: method_name(args)`",
              sql_line_index
            )
          end
          if sql?(sql_line)
            sql = parse_sql(sql_line, sql_line_index).strip
            @sql_lines << sql
          end
        end
        define_method(@metadata, @sql_lines.each.join("\\n"))
        @sql_lines.clear
      elsif malformed_metadata_hint?(line)
        raise_parse_error("invalid metadata format, expected `-- name: method_name(args)`", index)
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
    parse_sql(sql, nil)
  end

  def parse_sql(sql, line_index : Int32?)
    validate_placeholders!(sql, line_index)
    sql = sql.gsub(PARAM_RAW_RE) do |token, match|
      if match[1].strip.empty?
        raise_parse_error("raw parameter cannot be empty", line_index)
      end
      "\#{#{match[1]}}"
    end
    sql = sql.gsub(PARAM_RE) do |token, match|
      if match[1].strip.empty?
        raise_parse_error("parameter cannot be empty", line_index)
      end
      "\#{Tren.escape(#{match[1]})}"
    end
  end

  def validate_placeholders!(sql, line_index : Int32?)
    opening = sql.scan(/\{\{/).size
    closing = sql.scan(/\}\}/).size
    return if opening == closing

    raise_parse_error("unbalanced parameter placeholders in SQL", line_index)
  end

  def set_indent(sql)
    sql.lines.map do |line|
      "  #{line}"
    end.join("").strip
  end

  def malformed_metadata_hint?(line)
    line.chomp.match(NAME_HINT_RE) && !metadata?(line)
  end

  def raise_parse_error(message, line_index : Int32?)
    line = line_index ? line_index.not_nil! + 1 : "?"
    raise ParseError.new("#{source_reference}:#{line} #{message}")
  end

  def source_reference
    @source
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
