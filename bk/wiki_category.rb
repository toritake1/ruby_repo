require 'nokogiri'
require 'open-uri'

searchfile = "category_search_list.txt"
listfile = "category_name_list.txt"

if File.exist?(searchfile)
  searchs = File.open(searchfile).readlines
else
  puts "file not found."
end

UserAgent = 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0)'

for search in searchs
	html = open(search.chomp, 'User-Agent' => UserAgent).read
	doc = Nokogiri::HTML(html)

	doc.xpath('//div[@class="CategoryTreeItem"]/a').each do |element|
		puts element.text
	end
	
#	member_list = members.css("li")
#	member_list.each do |member|
#		puts member.css('a').inner_text

#		File.open(listfile,"a") do |file|
#			file.puts member.css('a').inner_text
#		end
#	end
#	sleep(1)
end
