get '/decrypt' do
  require_login
  @hasil = params['data']
  erb :decrypt
end

post '/decrypt' do
  require_login
  scheduler = Rufus::Scheduler.new
  if params['file']
    time = Time.new
    filename = "#{time.strftime('%s')}#{rand(1..100)}.png"

    image_path = "/temp/#{filename}"
    decrypt_stegano(ChunkyPNG::Image.from_file(params[:file][:tempfile]), "./public#{image_path}")
  end
  scheduler.at(Time.now + 300) do
    File.delete(image_path)
    File.delete(filename)
  end
  redirect "/decrypt?data=#{image_path}"
end
