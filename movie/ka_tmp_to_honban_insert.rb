require 'mysql2'
require 'time'
require 'active_support/all'

client = Mysql2::Client.new(:host => 'localhost', :username => 'root', :password => 'rootpass')

ka_res = client.query("select * from idol_development.ka_tmp_movies LIMIT 1;")
ka_res.each do |ka_row|
	create_time = ka_row["created_at"].strftime("%Y-%m-%d")
	if create_time <= 1.week.ago.strftime("%Y-%m-%d") then
		id = ka_row["id"]
		list_id = ka_row["ka_idollist_id"]
		t = ka_row["movie_thumbnail"]
		u = ka_row["url"]
		d = ka_row["description"]
                l = ka_row["link"]
		ct = Time.now.strftime("%Y-%m-%d %H:%M:%S")
		ut = Time.now.strftime("%Y-%m-%d %H:%M:%S")
		#puts "INSERT IGNORE INTO idol_development.ka_movies VALUES (null, '#{id}', '#{t}', '#{u}', '#{d}', '#{ct}', '#{ut}');"
		client.query("INSERT IGNORE INTO idol_development.ka_movies VALUES (null, '#{list_id}', '#{t}', '#{u}', '#{d}', '#{l}', '#{ct}', '#{ut}');")
		puts 'insert to ' + d
		client.query("DELETE FROM idol_development.ka_tmp_movies WHERE id = '#{id}';")
		puts 'delete id=' + id.to_s
	end
end

