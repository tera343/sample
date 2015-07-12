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
		SELECT * FROM ziplist
	SQL
	@rows = @db.execute(sql)
	erb :index,layout: :layout
end
