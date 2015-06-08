module App
  class Server < Sinatra::Base

    enable :sessions

    $db = PG.connect({dbname: 'knickipedia'})

    configure :development do
      register Sinatra::Reloader
    end

    get('/') do
      erb :login
    end

    get('/login') do
      erb :login
    end

    post('/login') do
      email = params[:email]
      password = params[:password]

      query = "SELECT * FROM users WHERE email = $1 LIMIT 1"
      results = $db.exec_params(query, [email])
      user = results.first
      if user && user['password'] == password
        session[:user_id] = user['id']
        redirect '/dashboard'
      else
        @message = 'incorrect email or password'
        erb :login
      end
    end

    get('/dashboard') do
      user_id = session[:user_id] # retrieve the stored user id
      if user_id
        query = "SELECT * FROM users WHERE id = $1 LIMIT 1"
        results = $db.exec_params(query, [user_id])

        @user = results.first
        erb :dashboard
      else
        redirect '/'
      end
    end

    delete('/logout') do
      session[:user_id] = nil
      redirect '/'
    end

    get '/' do
      @users = db.exec "SELECT * FROM users"
      erb :dashboard
    end

    get '/users' do
      @users = $db.exec "SELECT * FROM users"
      erb :users
    end

    get '/users/:id' do
      @user = $db.exec_params( "SELECT * FROM users WHERE id = $1", [ params[:id] ] ).first
      @articles = $db.exec_params("SELECT * FROM articles WHERE user_id=$1", [ params[:id] ])
      # binding.pry
      erb :user
    end

    get '/articles' do
      @articles = $db.exec "SELECT articles.*, users.name AS user_name FROM articles LEFT JOIN users ON articles.user_id = users.id"
      erb :articles
    end

    get '/articles/:id' do
      @article = $db.exec_params("SELECT * FROM articles WHERE id=$1", [ params[:id] ]).first
      @user = $db.exec_params("SELECT * FROM users WHERE id=$1", [ @article["house_id"] ]).first
      erb :article
    end

    post '/articles/new' do
      result = $db.exec_params "INSERT INTO articles (name, content, user_id, created_at, last_edit) VALUES ($1, $2, $3, $4, $5) RETURNING id", [ params[:name], params[:content], params[:user_id], params[:created_at], params[:last_edit] ]
      redirect "/articles/#{ result.first["id"] }"
    end

    get '/articles/:id/edit' do
      @article = $db.exec_params("SELECT * FROM articles WHERE id=$1", [ params[:id] ]).first
      @users = $db.exec "SELECT * FROM users"
      erb :edit
    end

    patch '/articles/:id' do
      query = "UPDATE articles SET name=$1, content=$2, user_id=$3, created_at=$4, last_edit=$5 WHERE id=$6"
      $db.exec_params query, [ params[:name], params[:content], params[:user_id], params[:created_at], params[:last_edit], params[:id] ]
      redirect "/articles/#{ params[:id] }"
    end
  end
end