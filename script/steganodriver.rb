require 'chunky_png'
require_relative 'steganograte'
require_relative 'recoverate'

def encrypt_stegano(image)
  mask = ChunkyPNG::Image.from_file('./public/mask.png')
  mask.resample_bilinear!(image.width, image.height)
  time = Time.new
  name = "#{time.strftime("%s")}#{rand(1..100)}.png"
  Steganogrator.steganograte(mask, image, 8).save("./public/img/#{name}")
  name
end

def decrypt_stegano(image)
  time = Time.new
  name = "#{time.strftime("%s")}#{rand(1..100)}.png"
  Steganogrator.recoverate(image, 8).save("./public/temp/#{name}")
  name
end