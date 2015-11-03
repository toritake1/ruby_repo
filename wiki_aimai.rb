require 'wikipedia'
require 'mysql2'

wikifile = "/tmp/aimai.txt"
listfile = "/usr/local/sbin/idol/idol_list.txt"
#listfile = "test_list.txt"
aimaifile = "/usr/local/sbin/idol/aimai_name_list.txt"

if File.exist?(listfile)
  names = File.open(listfile).readlines
else
  puts "file not found."
end

for name in names
	puts name.chomp + " is check"
	# wiki情報取得
        page = Wikipedia.find(name.chomp)
	# wiki情報をファイルに出力
        File.write(wikifile, page.content)
	# ファイルサイズ取得
	w_size  =   File.size(wikifile)  

        if File.exist?(wikifile) && w_size != 0
		 tmpcheck = File.readlines(wikifile).grep(/人名の曖昧さ回避/)
	         if tmpcheck[0].nil? then
		       tmpcheck[0] = "none"
                 end	
		 check = tmpcheck[0].include?("人名の曖昧さ回避")
                 if check
			#puts name.chomp
	                File.open(aimaifile,"a") do |file|
                        file.puts name.chomp
                end

                 end
        end
	sleep(1)
end

