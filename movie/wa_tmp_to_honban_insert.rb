require 'mysql2'
require 'time'
require 'active_support/all'

client = Mysql2::Client.new(:host => 'localhost', :username => 'root', :password => 'rootpass')

wa_res = client.query("select * from idol_development.wa_tmp_movies LIMIT 1;")
wa_res.each do |wa_row|
	create_time = wa_row["created_at"].strftime("%Y-%m-%d")
	if create_time <= 1.week.ago.strftime("%Y-%m-%d") then
		id = wa_row["id"]
		list_id = wa_row["wa_idollist_id"]
		t = wa_row["movie_thumbnail"]
		u = wa_row["url"]
		d = wa_row["description"]
                l = wa_row["link"]
		ct = Time.now.strftime("%Y-%m-%d %H:%M:%S")
		ut = Time.now.strftime("%Y-%m-%d %H:%M:%S")
		#puts "INSERT IGNORE INTO idol_development.wa_movies VALUES (null, '#{id}', '#{t}', '#{u}', '#{d}', '#{ct}', '#{ut}');"
		client.query("INSERT IGNORE INTO idol_development.wa_movies VALUES (null, '#{list_id}', '#{t}', '#{u}', '#{d}', '#{l}', '#{ct}', '#{ut}');")
		puts 'insert to ' + d
		client.query("DELETE FROM idol_development.wa_tmp_movies WHERE id = '#{id}';")
		puts 'delete id=' + id.to_s
	end
end

