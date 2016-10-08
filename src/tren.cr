require "./tren/*"

module Tren
  macro load(filename)
    \{{ run("../src/reader", {{filename}}) }}
  end
end
