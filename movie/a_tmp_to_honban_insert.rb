require 'mysql2'
require 'time'
require 'active_support/all'

client = Mysql2::Client.new(:host => 'localhost', :username => 'root', :password => 'rootpass')

a_res = client.query("select * from idol_development.a_tmp_movies LIMIT 1;")
a_res.each do |a_row|
	create_time = a_row["created_at"].strftime("%Y-%m-%d")
	if create_time <= 1.week.ago.strftime("%Y-%m-%d") then
		id = a_row["id"]
		list_id = a_row["a_idollist_id"]
		t = a_row["movie_thumbnail"]
		u = a_row["url"]
		d = a_row["description"]
		l = a_row["link"]
		ct = Time.now.strftime("%Y-%m-%d %H:%M:%S")
		ut = Time.now.strftime("%Y-%m-%d %H:%M:%S")
		#puts "INSERT IGNORE INTO idol_development.a_movies VALUES (null, '#{id}', '#{t}', '#{u}', '#{d}', '#{ct}', '#{ut}');"
		client.query("INSERT IGNORE INTO idol_development.a_movies VALUES (null, '#{list_id}', '#{t}', '#{u}', '#{d}', '#{l}','#{ct}', '#{ut}');")
		puts 'insert to ' + d
		client.query("DELETE FROM idol_development.a_tmp_movies WHERE id = '#{id}';")
		puts 'delete id=' + id.to_s
	end
end

