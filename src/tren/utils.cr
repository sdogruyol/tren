module Tren
  # Overload Types
  def self.escape(str : String)
    str.gsub(/\\|'/) { |c| "\\#{c}" }
  end

  def self.escape(anything)
    anything
  end
end
