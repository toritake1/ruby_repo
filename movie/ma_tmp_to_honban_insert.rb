require 'mysql2'
require 'time'
require 'active_support/all'

client = Mysql2::Client.new(:host => 'localhost', :username => 'root', :password => 'rootpass')

ma_res = client.query("select * from idol_development.ma_tmp_movies LIMIT 1;")
ma_res.each do |ma_row|
	create_time = ma_row["created_at"].strftime("%Y-%m-%d")
	if create_time <= 1.week.ago.strftime("%Y-%m-%d") then
		id = ma_row["id"]
		list_id = ma_row["ma_idollist_id"]
		t = ma_row["movie_thumbnail"]
		u = ma_row["url"]
		d = ma_row["description"]
                l = ma_row["link"]
		ct = Time.now.strftime("%Y-%m-%d %H:%M:%S")
		ut = Time.now.strftime("%Y-%m-%d %H:%M:%S")
		#puts "INSERT IGNORE INTO idol_development.ma_movies VALUES (null, '#{id}', '#{t}', '#{u}', '#{d}', '#{ct}', '#{ut}');"
		client.query("INSERT IGNORE INTO idol_development.ma_movies VALUES (null, '#{list_id}', '#{t}', '#{u}', '#{d}', '#{l}', '#{ct}', '#{ut}');")
		puts 'insert to ' + d
		client.query("DELETE FROM idol_development.ma_tmp_movies WHERE id = '#{id}';")
		puts 'delete id=' + id.to_s
	end
end

