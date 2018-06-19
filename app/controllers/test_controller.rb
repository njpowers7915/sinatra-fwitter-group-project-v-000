class TestController < ApplicationController
    get 'test/' do
        erb :test_home
    end

    get 'test/login' do
        erb :test_login
    end

    post 'test/login' do
        erb :test_show
    end

    get 'test/signup' do
        erb :test_signup
    end

    post 'test/signup' do
        @user = User.new(email: params["email"], username: params["username"], password: params["password"])
        @user.save
        session[:user_id] = @user.id
        erb :test_show
    end

    get 'test/logout' do
        session.clear
        erb :test_home
    end
end
