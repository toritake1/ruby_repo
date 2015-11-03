require 'mysql2'
require 'time'
require 'active_support/all'

client = Mysql2::Client.new(:host => 'localhost', :username => 'root', :password => 'rootpass')

ra_res = client.query("select * from idol_development.ra_tmp_movies LIMIT 1;")
ra_res.each do |ra_row|
	create_time = ra_row["created_at"].strftime("%Y-%m-%d")
	if create_time <= 1.week.ago.strftime("%Y-%m-%d") then
		id = ra_row["id"]
		list_id = ra_row["ra_idollist_id"]
		t = ra_row["movie_thumbnail"]
		u = ra_row["url"]
		d = ra_row["description"]
                l = ra_row["link"]
		ct = Time.now.strftime("%Y-%m-%d %H:%M:%S")
		ut = Time.now.strftime("%Y-%m-%d %H:%M:%S")
		#puts "INSERT IGNORE INTO idol_development.ra_movies VALUES (null, '#{id}', '#{t}', '#{u}', '#{d}', '#{ct}', '#{ut}');"
		client.query("INSERT IGNORE INTO idol_development.ra_movies VALUES (null, '#{list_id}', '#{t}', '#{u}', '#{d}', '#{l}', '#{ct}', '#{ut}');")
		puts 'insert to ' + d
		client.query("DELETE FROM idol_development.ra_tmp_movies WHERE id = '#{id}';")
		puts 'delete id=' + id.to_s
	end
end

