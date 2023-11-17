configure do
  enable :sessions
end

helpers do
  def require_login
    redirect '/login' unless session[:userid]
  end
end

get '/' do
  require_login
  redirect '/messages'
end