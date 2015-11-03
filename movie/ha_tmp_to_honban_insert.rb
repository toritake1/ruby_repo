require 'mysql2'
require 'time'
require 'active_support/all'

client = Mysql2::Client.new(:host => 'localhost', :username => 'root', :password => 'rootpass')

ha_res = client.query("select * from idol_development.ha_tmp_movies LIMIT 1;")
ha_res.each do |ha_row|
	create_time = ha_row["created_at"].strftime("%Y-%m-%d")
	if create_time <= 1.week.ago.strftime("%Y-%m-%d") then
		id = ha_row["id"]
		list_id = ha_row["ha_idollist_id"]
		t = ha_row["movie_thumbnail"]
		u = ha_row["url"]
		d = ha_row["description"]
                l = ha_row["link"]
		ct = Time.now.strftime("%Y-%m-%d %H:%M:%S")
		ut = Time.now.strftime("%Y-%m-%d %H:%M:%S")
		#puts "INSERT IGNORE INTO idol_development.ha_movies VALUES (null, '#{id}', '#{t}', '#{u}', '#{d}', '#{ct}', '#{ut}');"
		client.query("INSERT IGNORE INTO idol_development.ha_movies VALUES (null, '#{list_id}', '#{t}', '#{u}', '#{d}', '#{l}', '#{ct}', '#{ut}');")
		puts 'insert to ' + d
		client.query("DELETE FROM idol_development.ha_tmp_movies WHERE id = '#{id}';")
		puts 'delete id=' + id.to_s
	end
end

