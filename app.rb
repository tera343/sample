require 'sinatra'
require 'sqlite3'
before do
	@db = SQLite3::Database.new("ziplist.db")
end
after do
	@db.close
end

get '/' do
	sql = <<-SQL
		SELECT * FROM ziplist;
	SQL
	@rows = @db.execute(sql)
	erb :index,layout: :layout
end

get '/new' do
	erb :new,layout: :layout
end

post '/new/receive' do
	@zipcode = params[:zipcode]
	@address = params[:address]
	sql = <<-SQL
		INSERT INTO ziplist(zipcode,address)
		VALUES("#{@zipcode}","#{@address}");
	SQL
	@db.execute(sql)
	redirect '/'
end

get '/edit/:id/receive' do
	@id = params["id"]
	@zipcode = params["zipcode"]
	@address = params["address"]
	sql = <<-SQL
		UPDATE ziplist SET zipcode = "#{@zipcode}",address = "#{@address}" WHERE id = "#{@id}"
	SQL
	@db.execute(sql)
	redirect '/'
end

get '/edit/:id' do
	@id = params["id"]
	erb :edit,layout: :layout
end

get '/delete/:id' do
	@id = params["id"]
	sql = <<-SQL
		DELETE FROM ziplist WHERE id = "#{@id}";
	SQL
	@db.execute(sql)
	redirect '/'
end