class SessionsController < ApplicationController
    register Sinatra::ActiveRecordExtension
    set :views, Proc.new { File.join(root, "../views/") }

    configure do
      enable :sessions
      set :session_secret, "secret"
    end

    get '/signup' do
        @user = Helpers.current_user(session)
        if Helpers.is_logged_in?(session) == false
            erb :'/users/signup'
        else
            redirect '/tweets'
        end
    end

    post '/signup' do
        @user = User.new(:email => params[:email], :username => params[:username], :password => params[:password])
        if params[:username] == "" || params[:password] == "" || params[:email] == ""
          redirect '/signup'
        else
          @user.save
          session[:user_id] = @user.id
          redirect '/tweets'
        end
    end

    get '/login' do
        erb :'users/login'
    end

    post '/login' do
        @user = User.find_by(:username => params[:username])
        if @user && @user.authenticate(params[:password])
            session[:user_id] = user.id
            redirect '/tweets'
        else
            redirect '/login'
        end
    end

    get '/tweets' do
        #"Welcome #{session[:username]}"
        @user = User.find_by(id: session[:user_id])
        erb :"tweets/tweets"
    end

    get '/logout' do
        session.clear
        erb :home
    end


end
