require 'mysql2'
require 'time'
require 'active_support/all'

client = Mysql2::Client.new(:host => 'localhost', :username => 'root', :password => 'rootpass')

ta_res = client.query("select * from idol_development.ta_tmp_movies LIMIT 1;")
ta_res.each do |ta_row|
	create_time = ta_row["created_at"].strftime("%Y-%m-%d")
	if create_time <= 1.week.ago.strftime("%Y-%m-%d") then
		id = ta_row["id"]
		list_id = ta_row["ta_idollist_id"]
		t = ta_row["movie_thumbnail"]
		u = ta_row["url"]
		d = ta_row["description"]
                l = ta_row["link"]
		ct = Time.now.strftime("%Y-%m-%d %H:%M:%S")
		ut = Time.now.strftime("%Y-%m-%d %H:%M:%S")
		#puts "INSERT IGNORE INTO idol_development.ta_movies VALUES (null, '#{id}', '#{t}', '#{u}', '#{d}', '#{ct}', '#{ut}');"
		client.query("INSERT IGNORE INTO idol_development.ta_movies VALUES (null, '#{list_id}', '#{t}', '#{u}', '#{d}', '#{l}', '#{ct}', '#{ut}');")
		puts 'insert to ' + d
		client.query("DELETE FROM idol_development.ta_tmp_movies WHERE id = '#{id}';")
		puts 'delete id=' + id.to_s
	end
end

