require 'csv'

output = File.open('ziplist.dat', 'w')

open('20NAGANO.csv', "rb:Shift_JIS:UTF-8", undef: :replace) do |f|
  CSV.new(f, converters: nil).each_with_index do |row, index|
    h = {
      zipcode: row[2],
      address: row[6..8].join
    }

    output.puts  [index + 1,h[:zipcode], h[:address]].join(",")
  end
end

output.close
