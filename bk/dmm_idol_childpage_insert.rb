require 'nokogiri'
require 'open-uri'

UserAgent = 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0)'

html = open('http://www.dmm.com/digital/idol/-/list/=/article=actor/id=66805/', 'User-Agent' => UserAgent).read
doc = Nokogiri::HTML(html)

items = doc.xpath('//p[@class="tmb"]')
items.each do |item|
	#puts item.css('a').attribute('href').value
	#puts item.css('img').attribute('src').value
	#puts item.css('img').attribute('alt').value
	puts item.css('img').attribute('alt').value + ',' + item.css('img').attribute('src').value + ',' + item.css('a').attribute('href').value
end
