require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    enable :sessions
    set :session_secret, 'secret'
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get '/' do
    erb :home
  end

  get '/index' do
    erb :index
  end

  get '/signup' do
    @user = Helpers.current_user(session)
    if Helpers.is_logged_in?(session) == false
        erb :'/users/signup'
    else
        erb :error
    end
  end

  post "/signup" do
      @user = User.new(email: params[:email], username: params[:username], password: params[:password])
      if params[:username] == "" || params[:password] == "" || params[:email] == ""
          redirect "/signup"
      else
          @user.save
          session[:id] = @user.id
          redirect "/tweets/tweets"
      end
  end

  get '/login' do
    erb :'/users/login'
  end

  post '/sessions' do
    @user = User.find_by(username: params["username"], password: params["password"])
    if @user.nil?
        redirect '/login'
    else
        session[:id] = @user.id
        redirect '/users/show'
    end
  end

end
