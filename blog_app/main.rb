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
  enable :sessions
end

get '/' do
  @posts = @db.exec("select * from blog;")
haml :index
end

get '/admin_connect' do
  if params["username"] == "andrea" && params["password"] == "password"
    session[:admin] = true
    redirect to '/admin' #page not created yet...
  end
  haml :admin_connect
end

get '/admin' do
  unless session[:admin] == true
    redirect to '/'
  end
  @posts = @db.exec("select * from blog;")
  haml :admin
end

get '/edit/:id' do
@edit_post = @db.exec("select * from blog where id = '#{params[:id]}';").first
haml :edit
end

post '/edit/:id' do
  if params[:title]
  @update_post = @db.exec("update blog set title='#{params[:title]}, content='#{params['content']}, created_at='#{params[:created_at]} where if=#{params[:id]};")
  end
  haml :edit
end

get '/delete/:id' do
  @deleted_post = @db.exec("select * from blog where id = '#{params[:id]}';").first
  @delete_post = @db.exec("delete from blog where id = '#{params[:id]}';").first
  haml :delete
end







