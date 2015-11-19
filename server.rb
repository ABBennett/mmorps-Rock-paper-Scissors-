require "sinatra"
require 'pry'

use Rack::Session::Cookie, {
  secret: "keep_it_secret_keep_it_safe"
}

get '/index' do

  if session[:visit_count].nil?
    session[:visit_count] = 1
  session[:user_score] = 0
  session[:comp_score] = 0
  else
    session[:visit_count] += 1
  end

  if session[:user_score].to_i > 1
    @win = true

  elsif session[:comp_score].to_i > 1
    @win = false
  end

  erb :index
end

post '/choose' do
  @win = nil
  @tie = false
  choices = ["Rock", "Paper", "Scissors"]

  session[:user_choice] = params[:choice]
  session[:comp_choice] = choices.sample


    if session[:user_choice] == session[:comp_choice]
      @tie = true
    elsif session[:user_choice] == "Rock"
      if session[:comp_choice] == "Paper"
        session[:comp_score] += 1
      else
        session[:user_score] += 1
      end

    elsif session[:user_choice] == "Paper"
      if session[:comp_choice] == "Scissors"
        session[:comp_score] += 1
      else
        session[:user_score] += 1
      end

    elsif session[:user_choice] == "Scissors"
      if session[:comp_choice] == "Rock"
        session[:comp_score] += 1
      else
        session[:user_score] += 1
      end
    end



  redirect '/index'
end


post '/reset' do
  session.clear
  redirect '/index'
end
