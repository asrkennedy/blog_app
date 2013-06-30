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

get '/show_post/:id' do
  @show_post = @db.exec("select * from blog where id = '#{params[:id]}';")
  haml :show_post
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
  @update_post = @db.exec("update blog set title='#{params[:title]}', content='#{params['content']}', created_at='#{params[:created_at]}' where id='#{params[:id]}';")
  redirect to '/admin'
  end
  haml :edit
end

get '/delete/:id' do
  @deleted_post = @db.exec("select * from blog where id = '#{params[:id]}';").first
  @delete_post = @db.exec("delete from blog where id = '#{params[:id]}';").first
  redirect to '/admin'
  haml :delete
end

get '/create' do
    if params.any?
    @create_post = @db.exec("insert into blog (title, content, created_at) values ('#{params['title']}', '#{params['content']}', '#{params['created_at']}');")
    redirect to '/admin'
  end
  haml :create
end






