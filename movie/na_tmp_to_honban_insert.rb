require 'mysql2'
require 'time'
require 'active_support/all'

client = Mysql2::Client.new(:host => 'localhost', :username => 'root', :password => 'rootpass')

na_res = client.query("select * from idol_development.na_tmp_movies LIMIT 1;")
na_res.each do |na_row|
	create_time = na_row["created_at"].strftime("%Y-%m-%d")
	if create_time <= 1.week.ago.strftime("%Y-%m-%d") then
		id = na_row["id"]
		list_id = na_row["na_idollist_id"]
		t = na_row["movie_thumbnail"]
		u = na_row["url"]
		d = na_row["description"]
                l = na_row["link"]
		ct = Time.now.strftime("%Y-%m-%d %H:%M:%S")
		ut = Time.now.strftime("%Y-%m-%d %H:%M:%S")
		#puts "INSERT IGNORE INTO idol_development.na_movies VALUES (null, '#{id}', '#{t}', '#{u}', '#{d}', '#{ct}', '#{ut}');"
		client.query("INSERT IGNORE INTO idol_development.na_movies VALUES (null, '#{list_id}', '#{t}', '#{u}', '#{d}', '#{l}', '#{ct}', '#{ut}');")
		puts 'insert to ' + d
		client.query("DELETE FROM idol_development.na_tmp_movies WHERE id = '#{id}';")
		puts 'delete id=' + id.to_s
	end
end

