require "./tren/*"

module Tren
  macro load(filename)
    \{{ run("#{{{__DIR__}}}/reader", {{filename}}) }}
  end
end
