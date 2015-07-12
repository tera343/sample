require 'sinatra'
require 'sqlite3'

get '/' do
	
	erb :index,layout: :layout
end
