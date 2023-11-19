get '/login' do
  redirect '/' if session[:userid]
  erb :login
end

post '/login' do
  username = Digest::SHA256.hexdigest(params['username'])
  password = Digest::SHA256.hexdigest(username + params['password'])

  user = User.find_by(username: username, password: password)

  if user
    session[:userid] = user.userid
    redirect '/'
  else
    error = 'username/password salah'
    redirect "/login?error=#{URI.encode_www_form_component(error)}"
  end
end

get '/register' do
  redirect '/' if session[:userid]
  erb :register
end

post '/register' do
  displayname = params['displayname']
  username = Digest::SHA256.hexdigest(params['username'])
  password = Digest::SHA256.hexdigest(username + params['password'])

  begin
    existing_user = User.find_by(username: username)
    raise 'Username sudah ada' if existing_user
  rescue StandardError => e
    redirect "/register?error=#{URI.encode_www_form_component(e.message)}"
  end

  User.create(username: username, password: password, displayname: displayname)
  redirect '/'
end

get '/logout' do
  session[:userid] ? session.delete(:userid) : ''
  redirect '/login'
end

not_found do
  redirect '/'
end