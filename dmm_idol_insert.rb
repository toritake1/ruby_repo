require 'nokogiri'
require 'open-uri'
require 'mysql2'

searchfile = "/usr/local/sbin/idol/dmm_search_list.txt"
#searchfile = "test_search_list.txt"

if File.exist?(searchfile)
  searchs = File.open(searchfile).readlines
else
  puts "file not found."
end

UserAgent = 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0)'
client = Mysql2::Client.new(:host => 'localhost', :username => 'root', :password => 'rootpass')
DMM_URL = 'http://www.dmm.com/digital/idol/-/actor/=/keyword='

cnt = 0
dcnt = 0
for search in searchs
	html = open(DMM_URL + search.chomp + '/', 'User-Agent' => UserAgent).read
	doc = Nokogiri::HTML(html)

	members = doc.xpath('//ul[@class="act-box-65 group mg-b20"]')
	member_list = members.css("li")
	member_list.each do |member|
		 cnt += 1
		# name
		tmp_n = member.css('a').inner_text
                check = tmp_n.include?("（")
                if check
                	tmpn = tmp_n.split("（")
                 	n = tmpn[0]
                else
			n = tmp_n
                end
		# thumbnail
		#t = member.css('img').attribute('src').value
		# link
		l = "http://www.dmm.com" + member.css('a').attribute('href').value
		
        	#puts "INSERT INTO idol.main VALUES ('#{cnt}', '#{n}', '#{t}', '#{l}');"
        	puts "main insert to " + n
        	#client.query("INSERT IGNORE INTO idol.main VALUES ('#{cnt}', '#{n}', '#{t}', '#{l}');")
        	client.query("INSERT IGNORE INTO idol.main VALUES ('#{cnt}', '#{n}', '#{t}', '#{l}');")

		# detail page
		d_html = open(l, 'User-Agent' => UserAgent).read
		d_doc = Nokogiri::HTML(d_html)

		d_items = d_doc.xpath('//p[@class="tmb"]')
		d_items.each do |d_item|
			dcnt += 1	
			tmp_dti = d_item.css('img').attribute('alt').value
                	check = tmp_dti.include?("'")
                	if check
                        	tmpdti = tmp_dti.gsub(/\'/,"’")
                        	dti = tmpdti
                	else
                        	dti = tmp_dti
                	end
        		dth = d_item.css('img').attribute('src').value
			dl = d_item.css('a').attribute('href').value
			#puts "INSERT INTO idol.main VALUES ('#{dcnt}', '#{n}', '#{dti}', '#{dth}', '#{dl}');"
			puts "detail insert to " + n
        		client.query("INSERT INTO idol.detail VALUES ('#{dcnt}', '#{n}', '#{dti}', '#{dth}', '#{dl}');")
		end
	sleep(1)
	end
	sleep(1)
end

