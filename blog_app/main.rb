require 'pry'
require 'sinatra'
require 'sinatra/contrib/all' if development?
require 'pg'
require 'haml'

before do
  @db = PG.connect(dbname: 'blog')
end

# after do
#   db.close
# end

configure do
  enable :session
  set :environment, 'development'
end

get '/' do
  @posts = @db.exec("select * from blog;")
haml :index
end

# get '/admin_connect' do
#   if params["login"]== "andrea" and params["password"]=="password"
#     session[:admin] = true
#     redirect "/admin" #page not created yet...
# end

# get '/admin' do
#   unless session[:admin] == true
#     redirect "/"
# end