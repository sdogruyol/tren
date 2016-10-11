module Tren
  def self.escape(str : String)
    str.gsub(/\\|'/) { |c| "\\#{c}" }
  end
end