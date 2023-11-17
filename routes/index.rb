get '/all' do
  require_login
  @displayname = User.find(session[:userid]).displayname
  @users = User.where.not(userid: session[:userid])
  @search = true
  erb :index
end

get '/messages/?:userid?' do
  require_login

  subquery = Message.select('MAX(messageid) AS max_id')
                    .group('LEAST(senderid, receiverid), GREATEST(senderid, receiverid)')

  @users = Message.select('messages.*, users.userid, users.displayname')
                  .joins('INNER JOIN users ON (messages.senderid = users.userid OR messages.receiverid = users.userid)')
                  .where("(messages.senderid = ? OR messages.receiverid = ?) AND messages.messageid IN (#{subquery.to_sql})", session[:userid], session[:userid])
                  .where.not('users.userid = ?', session[:userid])

  @displayname = User.find(session[:userid]).displayname

  if params[:userid]
    begin
      @receiver = User.find(params[:userid])
      @messages = Message.where('(senderid = ? AND receiverid = ?) OR (senderid = ? AND receiverid = ?)',
                                session[:userid], params[:userid], params[:userid], session[:userid]).order('timestamp ASC')

      @messages.each do |message|
        sender_id = Message.find(message.messageid).receiverid
        sender_username = User.find(sender_id).username
        message.content = decrypt_aes(message.content, sender_username)
      end

      @show_right_partial = true
    rescue ActiveRecord::RecordNotFound
      redirect '/'
    end
  end

  erb :index
end

post '/messages/:userid' do
  require_login
  content = params['content']

  content = encrypt_reverse(content) if params['reverse'] == 'benar'

  username = User.find(params['receiverid']).username
  content = encrypt_aes(content, username)
  if params['file']
    filename = params[:file][:filename]
    file = params[:file][:tempfile]

    File.open("./public/img/#{filename}", 'wb') do |f|
      f.write(file.read)
    end
    
    if params['reverse'] == 'benar'
      image_path = "./public/img/#{filename}"
      newfilename = encrypt_stegano(ChunkyPNG::Image.from_file(image_path))
      filename = "/img/#{newfilename}"
    else
      filename = "/img/#{filename}"
    end
    
  end

  
  Message.create(senderid: session[:userid], receiverid: params['receiverid'], content: content, image_url: filename)
  params.delete('file')
  redirect "/messages/#{params['receiverid']}"
end
