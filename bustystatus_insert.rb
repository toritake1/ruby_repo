require 'nokogiri'
require 'open-uri'
require 'uri'
require 'mysql2'
require 'rexml/document'
require 'time'
require 'active_support/all'

searchfile = "bustystatus_idol_list.txt"

if File.exist?(searchfile)
  searchs = File.open(searchfile).readlines
else
  puts "file not found."
end

bustystatus_url = 'http://www.bustystatus.com/archives/tag/'
UserAgent = 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0)'
client = Mysql2::Client.new(:host => 'localhost', :username => 'root', :password => 'rootpass')

id = 0
movie_url = "none"
thumbnail_url = "none"
for search in searchs
	a_res = client.query("select id from idol_development.a_idollists where idol_name = '#{search.chomp}';")
	a_res.each do |a_row|
		id = a_row["id"]
	end
	ka_res =client.query("select id from idol_development.ka_idollists where idol_name = '#{search.chomp}';")
        ka_res.each do |ka_row|
                id = ka_row["id"]
        end
	sa_res =client.query("select id from idol_development.sa_idollists where idol_name = '#{search.chomp}';")
        sa_res.each do |sa_row|
                id = sa_row["id"]
        end
	ta_res =client.query("select id from idol_development.ta_idollists where idol_name = '#{search.chomp}';")
        ta_res.each do |ta_row|
                id = ta_row["id"]
        end
	na_res =client.query("select id from idol_development.na_idollists where idol_name = '#{search.chomp}';")
        na_res.each do |na_row|
                id = na_row["id"]
        end
	ha_res =client.query("select id from idol_development.ha_idollists where idol_name = '#{search.chomp}';")
        ha_res.each do |ha_row|
                id = ha_row["id"]
        end
	ma_res =client.query("select id from idol_development.ma_idollists where idol_name = '#{search.chomp}';")
        ma_res.each do |ma_row|
                id = ma_row["id"]
        end
	ya_res =client.query("select id from idol_development.ya_idollists where idol_name = '#{search.chomp}';")
        ya_res.each do |ya_row|
                id = ya_row["id"]
        end
	ra_res =client.query("select id from idol_development.ra_idollists where idol_name = '#{search.chomp}';")
        ra_res.each do |ra_row|
                id = ra_row["id"]
        end
	wa_res =client.query("select id from idol_development.wa_idollists where idol_name = '#{search.chomp}';")
        wa_res.each do |wa_row|
                id = wa_row["id"]
        end

        url = URI.encode(bustystatus_url + search.chomp)
        #url = URI.encode(bustystatus_url + search.chomp + '/page/2')
	html = open(url, 'User-Agent' => UserAgent).read
	doc = Nokogiri::HTML(html)

	items = doc.xpath('//*[@class="container_12 grid_10 push_5"]//h2')
	items.each do |item|
        	link = item.css('a').attribute('href').value
		desc = item.css('a').text

        	d_html = open(link, 'User-Agent' => UserAgent).read
        	d_doc = Nokogiri::HTML(d_html)

        	d_items = d_doc.xpath('//*[@class="entry-content"]')
        	d_items.each do |d_item|
                	# nikoniko
                	unless d_item.css('script')[0].nil?
                	  if d_item.css('script')[0].attribute('src').value.include?("nicovideo.jp") then
                        	# get movie
                        	niko_script = d_item.css('script')[0]
                        	niko_noscript = d_item.css('noscript')[0]
                        	unless niko_script.nil? || niko_noscript.nil?
                                	niko_script << niko_noscript
                                	script = niko_script
                        	end
                        	tag = script
                        	unless tag.nil?
                                	#puts tag
					movie_url = tag
                        	end

                        	# get thumbnail
                        	tmp_niko_id = d_item.css('script')[0].attribute('src').value.split('/')
                        	niko_id = tmp_niko_id[4].split('?')
                        	module NicovideoAPIWrapper extend self
                                	def get_thumb_info_xml(id)
                                        	open("http://ext.nicovideo.jp/api/getthumbinfo/#{id}") {|f|
                                                	return REXML::Document.new(f)
                                        	}
                                	end
                        	end
                        	xmldoc = NicovideoAPIWrapper::get_thumb_info_xml(niko_id[0])
                        	tmp_thumbnail_url = xmldoc.elements['nicovideo_thumb_response/thumb/thumbnail_url'].text + ".L"
                        	code = Net::HTTP.get_response(URI.parse(tmp_thumbnail_url)).code
                        	if code == '404' then
                                	thumbnail_url = xmldoc.elements['nicovideo_thumb_response/thumb/thumbnail_url'].text
                        	else
                                	thumbnail_url = tmp_thumbnail_url
                        	end
				#puts thumbnail_url

                	  end
			end

                	# youtube
                	unless d_item.css('iframe')[0].nil? 
			  if d_item.css('iframe')[0].attribute('src').value.include?("youtube.com") then
                        	# get movie
                        	iframe = d_item.css('iframe')[0]
                        	tag = iframe
                        	you_check = tag.nil?
                        	unless you_check
                                	#puts tag
                                	movie_url = tag
                        	end

                        	# get thumbnail
                        	tmp_you_id = d_item.css('iframe')[0].attribute('src').value.split('/')
				if tmp_you_id[4].include?("?feature=oembed") then
					you_id = tmp_you_id[4].split("?")
					thumbnail_url = "http://i.ytimg.com/vi/" + you_id[0] + "/mqdefault.jpg"
				else
                        		thumbnail_url = "http://i.ytimg.com/vi/" + tmp_you_id[4] + "/mqdefault.jpg"
				end
                        	#puts thumbnail_url
			  end
                	end

        	end
	
	#puts "INSERT INTO idol_development.tmp_movie VALUES ('#{id}', '#{thumbnail_url}', '#{movie_url}', '#{desc}');"
	a_cnt = client.query("select count(*) from idol_development.a_idollists where idol_name = '#{search.chomp}';")
        a_cnt.each do |a_cnt|
                cnt = a_cnt["count(*)"]
                if cnt == 1 && movie_url != 'none' then
                        time = 1.week.ago.strftime("%Y-%m-%d %H:%M:%S")
                        client.query("INSERT IGNORE INTO idol_development.a_tmp_movies VALUES (null, '#{id}', '#{thumbnail_url}', '#{movie_url}', '#{desc}', '#{link}', '#{time}', '#{time}');")
                        puts search.chomp + 'insert'
                end
        end
        ka_cnt = client.query("select count(*) from idol_development.ka_idollists where idol_name = '#{search.chomp}';")
        ka_cnt.each do |ka_cnt|
                cnt = ka_cnt["count(*)"]
		if cnt == 1 && movie_url != 'none' then
			time = 1.week.ago.strftime("%Y-%m-%d %H:%M:%S")
			client.query("INSERT IGNORE INTO idol_development.ka_tmp_movies VALUES (null, '#{id}', '#{thumbnail_url}', '#{movie_url}', '#{desc}', '#{link}','#{time}', '#{time}');")
			puts search.chomp + 'insert'
		end
        end
        sa_cnt = client.query("select count(*) from idol_development.sa_idollists where idol_name = '#{search.chomp}';")
        sa_cnt.each do |sa_cnt|
                cnt = sa_cnt["count(*)"]
                if cnt == 1 && movie_url != 'none' then
                        time = 1.week.ago.strftime("%Y-%m-%d %H:%M:%S")
                        client.query("INSERT IGNORE INTO idol_development.sa_tmp_movies VALUES (null, '#{id}', '#{thumbnail_url}', '#{movie_url}', '#{desc}', '#{link}','#{time}', '#{time}');")
                        puts search.chomp + 'insert'
                end
        end
        ta_cnt = client.query("select count(*) from idol_development.ta_idollists where idol_name = '#{search.chomp}';")
        ta_cnt.each do |ta_cnt|
                cnt = ta_cnt["count(*)"]
                if cnt == 1 && movie_url != 'none' then
                        time = 1.week.ago.strftime("%Y-%m-%d %H:%M:%S")
                        client.query("INSERT IGNORE INTO idol_development.ta_tmp_movies VALUES (null, '#{id}', '#{thumbnail_url}', '#{movie_url}', '#{desc}', '#{link}','#{time}', '#{time}');")
                        puts search.chomp + 'insert'
                end
        end
        na_cnt = client.query("select count(*) from idol_development.na_idollists where idol_name = '#{search.chomp}';")
        na_cnt.each do |na_cnt|
                cnt = na_cnt["count(*)"]
                if cnt == 1 && movie_url != 'none' then
                        time = 1.week.ago.strftime("%Y-%m-%d %H:%M:%S")
                        client.query("INSERT IGNORE INTO idol_development.na_tmp_movies VALUES (null, '#{id}', '#{thumbnail_url}', '#{movie_url}', '#{desc}', '#{link}','#{time}', '#{time}');")
                        puts search.chomp + 'insert'
                end
        end
        ha_cnt = client.query("select count(*) from idol_development.ha_idollists where idol_name = '#{search.chomp}';")
        ha_cnt.each do |ha_cnt|
                cnt = ha_cnt["count(*)"]
                if cnt == 1 && movie_url != 'none' then
                        time = 1.week.ago.strftime("%Y-%m-%d %H:%M:%S")
                        client.query("INSERT IGNORE INTO idol_development.ha_tmp_movies VALUES (null, '#{id}', '#{thumbnail_url}', '#{movie_url}', '#{desc}', '#{link}','#{time}', '#{time}');")
                        puts search.chomp + 'insert'
                end
        end
        ma_cnt = client.query("select count(*) from idol_development.ma_idollists where idol_name = '#{search.chomp}';")
        ma_cnt.each do |ma_cnt|
                cnt = ma_cnt["count(*)"]
                if cnt == 1 && movie_url != 'none' then
                        time = 1.week.ago.strftime("%Y-%m-%d %H:%M:%S")
                        client.query("INSERT IGNORE INTO idol_development.ma_tmp_movies VALUES (null, '#{id}', '#{thumbnail_url}', '#{movie_url}', '#{desc}', '#{link}','#{time}', '#{time}');")
                        puts search.chomp + 'insert'
                end
        end
        ya_cnt = client.query("select count(*) from idol_development.ya_idollists where idol_name = '#{search.chomp}';")
        ya_cnt.each do |ya_cnt|
                cnt = ya_cnt["count(*)"]
                if cnt == 1 && movie_url != 'none' then
                        time = 1.week.ago.strftime("%Y-%m-%d %H:%M:%S")
                        client.query("INSERT IGNORE INTO idol_development.ya_tmp_movies VALUES (null, '#{id}', '#{thumbnail_url}', '#{movie_url}', '#{desc}', '#{link}','#{time}', '#{time}');")
                        puts search.chomp + 'insert'
                end
        end
        ra_cnt = client.query("select count(*) from idol_development.ra_idollists where idol_name = '#{search.chomp}';")
        ra_cnt.each do |ra_cnt|
                cnt = ra_cnt["count(*)"]
                if cnt == 1 && movie_url != 'none' then
                        time = 1.week.ago.strftime("%Y-%m-%d %H:%M:%S")
                        client.query("INSERT IGNORE INTO idol_development.ra_tmp_movies VALUES (null, '#{id}', '#{thumbnail_url}', '#{movie_url}', '#{desc}', '#{link}','#{time}', '#{time}');")
                        puts search.chomp + 'insert'
                end
        end
        wa_cnt = client.query("select count(*) from idol_development.wa_idollists where idol_name = '#{search.chomp}';")
        wa_cnt.each do |wa_cnt|
                cnt = wa_cnt["count(*)"]
                if cnt == 1 && movie_url != 'none'then
                        time = 1.week.ago.strftime("%Y-%m-%d %H:%M:%S")
                        client.query("INSERT IGNORE INTO idol_development.wa_tmp_movies VALUES (null, '#{id}', '#{thumbnail_url}', '#{movie_url}', '#{desc}', '#{link}','#{time}', '#{time}');")
                        puts search.chomp + 'insert'
                end
        end


	sleep(1)
	end
end

