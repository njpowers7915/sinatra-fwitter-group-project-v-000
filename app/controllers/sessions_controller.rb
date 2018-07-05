class SessionsController < ApplicationController

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
        @user = Helpers.current_user(session)
        if Helpers.is_logged_in?(session) == false
            erb :'users/login'
        else
            redirect '/tweets'
        end
    end

    post '/login' do
        @user = User.find_by(:username => params[:username])
        if @user && @user.authenticate(params[:password])
            session[:user_id] = @user.id
            redirect '/tweets'
        else
            redirect '/login'
        end
    end

    get '/tweets' do
        #"Welcome #{session[:username]}"
        @user = Helpers.current_user(session)
        if Helpers.is_logged_in?(session) == false
            redirect '/login'
        else
            @user = User.find_by(id: session[:user_id])
            @tweets = Tweet.all
            erb :"tweets/tweets"
        end
    end

    get '/index' do
        @user = Helpers.current_user(session)
        if Helpers.is_logged_in?(session) == false
            redirect '/login'
        else
            #@user = User.find_by(id: session[:user_id])
            #@tweets = Tweet.all
            redirect '/tweets'
        end
    end

    get '/logout' do
        @user = Helpers.current_user(session)
        if Helpers.is_logged_in?(session)
            session.clear
            redirect '/login'
        else
            redirect '/'
        end
    end
        #if Helpers.is_logged_in?(session) == false
        #    redirect '/login'
        #else
end
