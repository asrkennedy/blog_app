require 'pry'
require 'sinatra'
require 'sinatra/contrib/all'
require 'pg'
require 'haml'

before do
  @db = PG.connect(dbname: 'blog')
end

after do
  @db.close
end

configure do
  enable :session
end

get '/' do
  @posts = @db.exec("select * from blog;")
haml :index
end

get '/admin_connect' do
  if params["username"] == "andrea" and params["password"] == "password"
    session[:admin] = true
    redirect "/admin" #page not created yet...
  end
  haml :admin_connect
end

get '/admin' do
  unless session[:admin] == true
    redirect "/"
  end

  @posts = @db.exec("select * from blog;")
  haml :admin
end

get '/edit' do
@edit_post = db.exec("select * from blog where id = '#{params[:id]}';").first
haml :edit
end

post '/edit' do
  if params[:title]
  @update_post = db.exec("update blog set title='#{params[:title]}, content='#{params['content']}, created_at='#{params[:created_at]} where if=#{params[:id]};")
  end
  haml :edit
end








