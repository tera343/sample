require 'sinatra'
require 'sqlite3'
before do
	@db = SQLite3::Database.new("ziplist.db")
end
after do
	@db.close
end

get '/' do #一覧の表示
	sql = <<-SQL
		SELECT * FROM ziplist;
	SQL
	@rows = @db.execute(sql)
	erb :index,layout: :layout
end

get '/new' do #データ入力ホーム
	erb :new,layout: :layout
end

post '/new/receive' do #/newから返ってきた値をDBに挿入
	@zipcode = params[:zipcode]
	@address = params[:address]
	sql = <<-SQL
		INSERT INTO ziplist(zipcode,address)
		VALUES("#{@zipcode}","#{@address}");
	SQL
	@db.execute(sql)
	redirect '/'
end

get '/edit/:id' do #データ編集ホーム
	@id = params["id"]
	erb :edit,layout: :layout
end

get '/edit/:id/receive' do #/editから返ってきた値にDBを更新
	@id = params["id"]
	@zipcode = params["zipcode"]
	@address = params["address"]
	sql = <<-SQL
		UPDATE ziplist SET zipcode = "#{@zipcode}",address = "#{@address}" WHERE id = "#{@id}"
	SQL
	@db.execute(sql)
	redirect '/'
end

get '/delete/:id' do #データをDBから削除する
	@id = params["id"]
	sql = <<-SQL
		DELETE FROM ziplist WHERE id = "#{@id}";
	SQL
	@db.execute(sql)
	redirect '/'
end

get '/search' do #検索ホーム
	erb :search,layout: :layout
end

post '/search/receive/zipcode_full' do
	@rows = []
	@zipcode_full = params[:zipcode_full]
	sql = <<-SQL
		SELECT * FROM ziplist;
	SQL
	result = @db.execute(sql)
	result.each do |row|
		if /#{row[1].to_s}/ =~ @zipcode_full.to_s
			@rows << row
		end
	end
	erb :index,layout: :layout
end

post '/search/receive/zipcode_part' do
	@rows = []
	@zipcode_part = params[:zipcode_part]
	sql = <<-SQL
		SELECT * FROM ziplist;
	SQL
	result = @db.execute(sql)
	result.each do |row|
		if /#{@zipcode_part.to_s}/ =~ row[1].to_s
			@rows << row
		end
	end
	erb :index,layout: :layout
end

post '/search/receive/address_full' do
	@rows = []
	@address_full = params[:address_full]
	sql = <<-SQL
		SELECT * FROM ziplist;
	SQL
	result = @db.execute(sql)
	result.each do |row|
		if /#{row[2]}/ =~ @address_full
			@rows << row
		end
	end
	erb :index,layout: :layout
end

post '/search/receive/address_part' do
	@rows = []
	@address_part = params[:address_part]
	sql = <<-SQL
		SELECT * FROM ziplist;
	SQL
	result = @db.execute(sql)
	result.each do |row|
		if /#{@address_part}/ =~ row[2]
			@rows << row
		end
	end
	erb :index,layout: :layout
end