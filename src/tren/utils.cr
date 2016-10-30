module Tren
  @@escape_character = "\\"

  def self.escape_character=(escape_character : String)
    @@escape_character = escape_character
  end

  # Overload Types
  def self.escape(str : String)
    str.gsub(/\\|'/) { |c| @@escape_character + c }
  end

  def self.escape(anything)
    anything
  end
end
