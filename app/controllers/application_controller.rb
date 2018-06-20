require './config/environment'
require 'pry'

class ApplicationController < Sinatra::Base
    register Sinatra::ActiveRecordExtension
    set :views, Proc.new { File.join(root, "../views/") }

    configure do
      enable :sessions
      set :session_secret, "secret"
    end

  get '/' do
    erb :home
  end

  get '/index' do
    erb :index
  end

  get '/tweets/new' do
      @user = Helpers.current_user(session)
      if Helpers.is_logged_in?(session) == false
          redirect '/login'
      else
          erb :'tweets/new'
      end
  end

  post '/tweets/new' do
      if params[:content] == ""
          redirect '/tweets/new'
      else
          @tweet = Tweet.new(:content => params[:content], :user_id => session[:user_id])
          @tweet.save
          redirect '/tweets'
      end
  end

  get '/tweets/:id' do
    @user = Helpers.current_user(session)
    if Helpers.is_logged_in?(session) == false
      redirect '/login'
    else
        @tweet = Tweet.find_by(id: params[:id])
        erb :'tweets/show'
    end
  end

  get '/tweets/:id/edit' do
    @user = Helpers.current_user(session)
    if Helpers.is_logged_in?(session) == false
      redirect '/login'
    else
        @tweet = Tweet.find_by(id: params[:id])
        if @tweet.user_id == session[:user_id]
            erb :'tweets/edit'
        else
            erb :error
        end
    end
  end

  patch '/tweets/:id' do
      @tweet = Tweet.find_by(id: params[:id])
      if params[:content] == ""
          redirect "tweets/#{@tweet.id}/edit"
      else
          @tweet.content = params["content"]
          @tweet.save
          redirect "tweets/#{@tweet.id}"
      end
  end

  delete '/tweets/:id/delete' do
      @user = Helpers.current_user(session)
      if Helpers.is_logged_in?(session) == false
        redirect '/login'
      else
          @tweet = Tweet.find_by(id: params[:id])
          if @tweet.user_id == session[:user_id]
              @tweet.destroy
              redirect '/tweets'
          end
      end
  end

end
