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

get '/messages' do
  require_login
  @users = User.where.not(userid: session[:userid])
  @displayname = User.find(session[:userid]).displayname
  erb :index
end

get '/messages/:userid' do
  require_login
  @users = User.where.not(userid: session[:userid])
  @displayname = User.find(session[:userid]).displayname
  begin
    @receiver = User.find(params['userid'])
    @messages = Message.where("(senderid = ? AND receiverid = ?) OR (senderid = ? AND receiverid = ?)",
                session[:userid], params['userid'], params['userid'], session[:userid]).order('timestamp ASC')
    @show_right_partial = true
    erb :index
  rescue ActiveRecord::RecordNotFound
    erb :index
  end
end

post '/messages/:userid' do
  require_login
  Message.create(senderid: session[:userid], receiverid: params['receiverid'], content: params['content'])
  redirect "/messages/#{params['receiverid']}"
end

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
    redirect '/login'
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

not_found do
  redirect '/'
end
