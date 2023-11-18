require_relative '../gcs_config'

storage = GCSConfig.storage
bucket = GCSConfig.bucket

get '/decrypt' do
  require_login
  filee = bucket.file "jawa.png"
  @hasil = filee.signed_url(expires: 3600)
  erb :decrypt
end

post '/decrypt' do
  require_login
  scheduler = Rufus::Scheduler.new
  if params['file']
    time = Time.new
    filename = "#{time.strftime('%s')}#{rand(1..100)}.png"
    file = params[:file][:tempfile]

    File.open("./public/temp/#{filename}", 'wb') do |f|
      f.write(file.read)
    end
    image_path = "./public/temp/#{filename}"
    filename = decrypt_stegano(ChunkyPNG::Image.from_file(image_path))
    filename = "/temp/#{filename}"
    File.delete(image_path)
  end
  scheduler.at(Time.now + 300) do
    File.delete(image_path)
    File.delete(filename)
  end
  redirect "/decrypt?data=#{filename}"
end
