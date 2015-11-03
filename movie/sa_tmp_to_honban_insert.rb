require 'mysql2'
require 'time'
require 'active_support/all'

client = Mysql2::Client.new(:host => 'localhost', :username => 'root', :password => 'rootpass')

sa_res = client.query("select * from idol_development.sa_tmp_movies LIMIT 1;")
sa_res.each do |sa_row|
	create_time = sa_row["created_at"].strftime("%Y-%m-%d")
	if create_time <= 1.week.ago.strftime("%Y-%m-%d") then
		id = sa_row["id"]
		list_id = sa_row["sa_idollist_id"]
		t = sa_row["movie_thumbnail"]
		u = sa_row["url"]
		d = sa_row["description"]
                l = sa_row["link"]
		ct = Time.now.strftime("%Y-%m-%d %H:%M:%S")
		ut = Time.now.strftime("%Y-%m-%d %H:%M:%S")
		#puts "INSERT IGNORE INTO idol_development.sa_movies VALUES (null, '#{id}', '#{t}', '#{u}', '#{d}', '#{ct}', '#{ut}');"
		client.query("INSERT IGNORE INTO idol_development.sa_movies VALUES (null, '#{list_id}', '#{t}', '#{u}', '#{d}', '#{l}', '#{ct}', '#{ut}');")
		puts 'insert to ' + d
		client.query("DELETE FROM idol_development.sa_tmp_movies WHERE id = '#{id}';")
		puts 'delete id=' + id.to_s
	end
end

