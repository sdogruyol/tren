module Tren
  @@escape_character = "\\"

  def self.escape_character=(escape_character : String)
    @@escape_character = escape_character
  end

  # Overload Types
  def self.escape(str : String)
    if @@escape_character == "\\'"
      # PostgreSQL string literals escape apostrophes by doubling them.
      str.gsub("'", "''")
    else
      str.gsub(/\\|'/) { |c| @@escape_character + c }
    end
  end

  def self.escape(anything)
    anything
  end
end
