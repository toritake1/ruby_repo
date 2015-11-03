require 'mysql2'
require 'time'
require 'active_support/all'

client = Mysql2::Client.new(:host => 'localhost', :username => 'root', :password => 'rootpass')

ya_res = client.query("select * from idol_development.ya_tmp_movies LIMIT 1;")
ya_res.each do |ya_row|
	create_time = ya_row["created_at"].strftime("%Y-%m-%d")
	if create_time <= 1.week.ago.strftime("%Y-%m-%d") then
		id = ya_row["id"]
		list_id = ya_row["ya_idollist_id"]
		t = ya_row["movie_thumbnail"]
		u = ya_row["url"]
		d = ya_row["description"]
                l = ya_row["link"]
		ct = Time.now.strftime("%Y-%m-%d %H:%M:%S")
		ut = Time.now.strftime("%Y-%m-%d %H:%M:%S")
		#puts "INSERT IGNORE INTO idol_development.ya_movies VALUES (null, '#{id}', '#{t}', '#{u}', '#{d}', '#{ct}', '#{ut}');"
		client.query("INSERT IGNORE INTO idol_development.ya_movies VALUES (null, '#{list_id}', '#{t}', '#{u}', '#{d}', '#{l}', '#{ct}', '#{ut}');")
		puts 'insert to ' + d
		client.query("DELETE FROM idol_development.ya_tmp_movies WHERE id = '#{id}';")
		puts 'delete id=' + id.to_s
	end
end

