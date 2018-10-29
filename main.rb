require 'nokogiri'
require 'HTTParty'
require 'open-uri'
require 'byebug'

# page = HTTParty.get('https://rogerebert.com/reviews/the-spectacular-now-2013')
page = Nokogiri::HTML(open('https://www.rogerebert.com/contributors/roger-ebert'))
grafs = []

text_arr = page.xpath('//h5[@class="title"]/a/@href').slice(0,4)

text_arr.each do |graf|
  grafs.push graf.text
end

File.open('The-Spectacular-Now', 'w+') do |f|
  f.write grafs
  f.close
end


# puts $LOAD_PATH