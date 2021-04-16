require 'rest-client'
require 'json'
require 'terminal-table'
require 'colorize'

days_to_get = ARGV[0] ? ARGV[0].to_i : 7

end_date = Date.today.strftime('%Y-%m-%d')
start_date = (Date.today - days_to_get).strftime('%Y-%m-%d')

url = 'https://api.coindesk.com/v1/bpi/historical/close.json'
params = "?start=#{start_date}&end=#{end_date}"

response = RestClient.get "#{url}#{params}", {
  content_type: :json,
  accept: :json
}

bpi = JSON.parse(response.body)["bpi"]
bpi_keys = bpi.keys

table_data = bpi.map.with_index do |(date, value), i|
  [
    Date.parse(date).strftime('%d/%m/%Y'),
    "$#{value.to_f}",
    i == 0 ? "—" : (bpi[bpi_keys[i]] > bpi[bpi_keys[i-1]] ? "🡅".colorize(:green) : "🡇".colorize(:red))
  ]
end

terminal_table = Terminal::Table.new :headings => ['Date', 'Bitcoin to US$', '📈'], :rows => table_data

puts terminal_table