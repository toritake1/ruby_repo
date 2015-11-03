require 'nokogiri'
require 'open-uri'

searchfile = "dmm_search_list.txt"
#searchfile = "test_search_list.txt"
listfile = "idol_list.txt"

if File.exist?(searchfile)
  searchs = File.open(searchfile).readlines
else
  puts "file not found."
end

UserAgent = 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0)'
DMM_URL = 'http://www.dmm.com/digital/idol/-/actor/=/keyword='

for search in searchs
	html = open(DMM_URL + search.chomp + '/', 'User-Agent' => UserAgent).read
	doc = Nokogiri::HTML(html)

	members = doc.xpath('//ul[@class="act-box-65 group mg-b20"]')
	member_list = members.css("li")
	member_list.each do |member|
                tmp_n = member.css('a').inner_text
                check = tmp_n.include?("（")
                if check
                        tmpn = tmp_n.split("（")
                        n = tmpn[0]
                else
                        n = tmp_n
                end
		puts n 
		File.open(listfile,"a") do |file|
			file.puts n
		end
	end
#	sleep(1)
end
