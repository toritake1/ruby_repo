require 'nokogiri'
require 'open-uri'
require 'uri'
require 'mysql2'
require 'rexml/document'

searchfile = "test_list.txt"

if File.exist?(searchfile)
  searchs = File.open(searchfile).readlines
else
  puts "file not found."
end

bustystatus_url = 'http://www.bustystatus.com/archives/tag/'
UserAgent = 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0)'

	 # nikoniko
         #url = 'http://www.bustystatus.com/archives/5029'
         url = 'http://www.bustystatus.com/archives/1479'
         # youtube
         #url = 'http://www.bustystatus.com/archives/1940'
         # fc2
         #url = 'http://www.bustystatus.com/archives/3369'

	html = open(url, 'User-Agent' => UserAgent).read
	doc = Nokogiri::HTML(html)

	items = doc.xpath('//*[@class="entry-content"]')
	items.each do |item|
		# nikoniko
		if item.css('script')[0].attribute('src').value.include?("nicovideo.jp") then
			# get movie
			niko_script = item.css('script')[0]
			niko_noscript = item.css('noscript')[0]
			unless niko_script.nil? || niko_noscript.nil?
				niko_script << niko_noscript
				script = niko_script
			end
			tag = script
			unless tag.nil?
				puts tag
			end
		
			# get thumbnail
			tmp_niko_id = item.css('script')[0].attribute('src').value.split('/')
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
			puts thumbnail_url	
		end

		# youtube
		unless item.css('iframe')[0].nil? 
			# get movie
        	        iframe = item.css('iframe')[0]
			tag = iframe
        		you_check = tag.nil?
        		unless you_check
                		puts tag
        		end

			# get thumbnail
			tmp_you_id = item.css('iframe')[0].attribute('src').value.split('/')
			thumbnail_url = "http://i.ytimg.com/vi/" + tmp_you_id[4] + "/mqdefault.jpg"
			puts thumbnail_url
		end
		
		# fc2
		if item.css('script')[0].attribute('src').value.include?("fc2.com") then
			# get movie
			fc2_script = item.css('script')[0]
			tag = fc2_script
			fc2_check = tag.nil?
			unless fc2_check
				puts tag
			end
		end
	end


