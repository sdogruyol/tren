require "./tren/utils"

module Tren
  macro load(filename)
    \{{ run("#{{{__DIR__}}}/tren/reader", {{filename}}) }}
  end
end
