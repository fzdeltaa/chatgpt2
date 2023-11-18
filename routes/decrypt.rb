require_relative '../gcs_config'

storage = GCSConfig.storage
bucket = GCSConfig.bucket

get '/decrypt' do
  require_login
  if params['data']
    filee = bucket.file params['data']
    @hasil = filee.signed_url(expires: 300)
  end
  erb :decrypt
end

post '/decrypt' do
  require_login
  if params['file']
    time = Time.new
    filename = "temp-#{time.strftime('%s')}#{rand(1..100)}.png"

    decrypt_stegano(ChunkyPNG::Image.from_file(params[:file][:tempfile]), filename)
  end
  redirect "/decrypt?data=#{filename}"
end
