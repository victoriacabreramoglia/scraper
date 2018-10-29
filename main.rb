require 'nokogiri'
require 'open-uri'
require 'byebug'
require 'marshal'
# Variable storage--put stuff here
critics = Marshal.load('critics_data')
byebug
page = Nokogiri::HTML(open('https://www.rogerebert.com/contributors'))
critic_links = []
review_links = []
review_bodies = []
critics_arr = []

# Populate the critics_arr with urls for each contributor
critics_list = page.xpath('//figcaption/h4/a/@href')
base_url = 'https://www.rogerebert.com'
critics_list.each do |critic|
  critic_url = base_url + critic.text
  critics_arr.push(
    {name:'',
    page_link: critic_url,
    reviews: []}
    )
end
# Visit each page, grab contributor name and last X reviews
# Doesn't yet filter for non-critic contributors
critics_arr.each do |critic|
  critic_page = Nokogiri::HTML(open(critic[:page_link]))
  critic[:name] = critic_page.xpath('//h1').text
  review_objs = critic_page.xpath('//h5/a/@href')
  review_links = []
  review_objs.each do |object|
    review_links.push object.text
  end
  critic[:reviews].push review_links.slice(0,7)
end
critic_storage = Marshal.dump(critics_arr)
File.open('critics_data', 'w+') do |f|
  f.write critic_storage
  f.close
end
review_links.each do |link|
  review_link = 'https://www.rogerebert.com/' + link
  review_page = Nokogiri::HTML(open(review_link))
  review_text = review_page.xpath('//div[@itemprop]/p').text
  review_bodies.push review_text
end

File.open('review_bodies', 'w+') do |f|
  f.write review_bodies
  byebug
  f.close
end

