require 'wikipedia'
require 'mysql2'

wikifile = "/tmp/wiki.txt"
listfile = "/usr/local/sbin/idol/idol_list.txt"
#listfile = "test_list.txt"

if File.exist?(listfile)
  names = File.open(listfile).readlines
else
  puts "file not found."
end

cnt = 0
for name in names
	# wiki情報取得
        page = Wikipedia.find(name.chomp)
	# wiki情報をファイルに出力
        File.write(wikifile, page.content)
	# ファイルサイズ取得
	w_size  =   File.size(wikifile)  

	cnt += 1
	puts "insert to " + name.chomp
        if File.exist?(wikifile) 
	     if w_size == 0
                  client = Mysql2::Client.new(:host => 'localhost', :username => 'root', :password => 'rootpass')
                  client.query("INSERT IGNORE INTO idol.profile VALUES ('#{cnt}', '#{name.chomp}', '0000-00-00', '0', '0', '0', '0', 'none','none');")
	     else
		 tmp_n = name.chomp

		 tmp_y = File.readlines(wikifile).grep(/\|\s*生年/)
		 if tmp_y[0].nil? then
                        tmp_y[0] = 0
                 end

		 tmp_m = File.readlines(wikifile).grep(/\|\s*生月/)
                 if tmp_m[0].nil? then
                        tmp_m[0] = 0
                 end

		 tmp_d = File.readlines(wikifile).grep(/\|\s*生日/)
                 if tmp_d[0].nil? then
                        tmp_d[0] = 0
                 end

		 tmp_s = File.readlines(wikifile).grep(/\|\s*身長/)
                 if tmp_s[0].nil? then
                        tmp_s[0] = 0
                 end

                 tmp_b = File.readlines(wikifile).grep(/\|\s*バスト/)
                 if tmp_b[0].nil? then
                        tmp_b[0] = 0
                 end

                 tmp_w = File.readlines(wikifile).grep(/\|\s*ウエスト/)
                 if tmp_w[0].nil? then
                        tmp_w[0] = 0
                 end

                 tmp_h = File.readlines(wikifile).grep(/\|\s*ヒップ/)
                 if tmp_h[0].nil? then
                        tmp_h[0] = 0
                 end

                 tmp_c = File.readlines(wikifile).grep(/\|\s*カップ/)
                 if tmp_c[0].nil? then
                        tmp_c[0] = "none"
                 end

                 tmp_t = File.readlines(wikifile).grep(/\*\s*\{\{Twitter\|/)
		 if tmp_t[0].nil? then
		 	tmp_t[0] = "none"
		 end

                 check = tmp_n.include?("_(")
                 if check
                     tmpn = tmp_n.split("_(")
                     n = tmpn[0]
                 else
                     n = tmp_n
                 end

                 if tmp_y[0] == 0
                        y = "0000"
                 else
                        y = tmp_y[0].gsub(/[^0-9]/,"")
                        y = y[0..3]
                        if y.empty? then
                                y = "0000"
                        end

                 end
                 if tmp_m[0] == 0
                        m = "00"
                 else
                        m = tmp_m[0].gsub(/[^0-9]/,"")
                        m = m[0..1]
                        if m.empty? then
                                m = "00"
                        end
                 end
                 if tmp_d[0] == 0
                        d = "00"
                 else
                        d = tmp_d[0].gsub(/[^0-9]/,"")
                        d = d[0..1]
                        if d.empty? then
                                d = "00"
                        end
                 end

                 ymd = y + '-' + m  + '-' + d

		 if tmp_s[0] == 0
			s = tmp_s[0]
		 else
                        check = tmp_s[0].include?("＝")
                        if check
                                tmps = tmp_s[0].split("＝")
                                s = tmps[1][0..3].gsub(/[^0-9]/,"")
                                if s.empty? then
                                        s = 0
                                end
                        else
                                tmps = tmp_s[0].split("=")
                                s = tmps[1][0..3].gsub(/[^0-9]/,"")
                                if s.empty? then
                                        s = 0
                                end
                        end
		 end

                 if tmp_b[0] == 0
			b = tmp_b[0]
		 else
                        check = tmp_b[0].include?("＝")
                        if check
                                tmpb = tmp_b[0].split("＝")
                                b = tmpb[1][0..3].gsub(/[^0-9]/,"")
                                if b.empty? then
                                        b = 0
                                end
                        else
                                tmpb = tmp_b[0].split("=")
                                b = tmpb[1][0..3].gsub(/[^0-9]/,"")
                                if b.empty? then
                                        b = 0
                                end
                        end
		 end
                 if tmp_w[0] == 0
			 w = tmp_w[0]
		 else
                        check = tmp_w[0].include?("＝")
                        if check
                                tmpw = tmp_w[0].split("＝")
                                w = tmpw[1][0..3].gsub(/[^0-9]/,"")
                                if w.empty? then
                                        w = 0
                                end
                        else
                                tmpw = tmp_w[0].split("=")
                                w = tmpw[1][0..3].gsub(/[^0-9]/,"")
                                if w.empty? then
                                        w = 0
                                end
                        end
		 end
                if tmp_h[0] == 0
			h = tmp_h[0]
		 else
                        check = tmp_h[0].include?("＝")
                        if check
                                tmph = tmp_h[0].split("＝")
                                h = tmph[1][0..3].gsub(/[^0-9]/,"")
                                if h.empty? then
                                        h = 0
                                end
                        else
                                tmph = tmp_h[0].split("=")
                                h = tmph[1][0..3].gsub(/[^0-9]/,"")
                                if h.empty? then
                                        h = 0
                                end
                        end
		 end
                 if tmp_c[0] == "none"
			 c = tmp_c[0]
		 else
                        check = tmp_c[0].include?("＝")
                        if check
                                tmpc = tmp_c[0].split("＝")
                                c = tmpc[1].gsub(/[^A-Z]/,"")[0..0]
                                if c.empty? then
                                        c = "none"
                                end
                        else
                                c = tmp_c[0].gsub(/[^A-Z]/,"")[0..0]
                                if c.empty? then
                                        c = "none"
                                end
                        end
		 end

		 if tmp_t[0] == "none"
			t = tmp_t[0]
		 else
                         tmpt =  tmp_t[0].gsub(/\**\s*\{\{\Twitter\|/,"").gsub(/\|(.+)/,"").gsub(/\}\}/,"").chomp
                         tmpt = tmpt.gsub(/（(.+)）/,"")
                         tmpt = tmpt.split(" ")
                         t = "https://twitter.com/" + tmpt[0]
		 end

                 client = Mysql2::Client.new(:host => 'localhost', :username => 'root', :password => 'rootpass')
		 #puts "INSERT INTO girls.profile VALUES ('#{n}', '#{ymd}', '#{s}', '#{b}', '#{w}', '#{h}', '#{c}','#{t}');"
                 client.query("INSERT IGNORE INTO idol.profile VALUES ('#{cnt}', '#{n}', '#{ymd}', '#{s}', '#{b}', '#{w}', '#{h}', '#{c}','#{t}');")
	   end
        else
                  puts name.chomp + " insert skip"
        end
	sleep(1)
end

