require 'chunky_png'
require_relative 'steganograte'
require_relative 'recoverate'
require_relative '../gcs_config'


def encrypt_stegano(image, name)
  bucket = GCSConfig.bucket
  mask = ChunkyPNG::Image.from_file('./public/mask.png')
  mask.resample_bilinear!(image.width, image.height)
  # Steganogrator.steganograte(mask, image, 8).save("./public/img/#{name}")

  bucket.create_file StringIO.new(Steganogrator.steganograte(mask, image, 8).to_blob), name
  name
end

def decrypt_stegano(image, name)
  bucket = GCSConfig.bucket
  bucket.create_file StringIO.new(Steganogrator.recoverate(image, 8).to_blob), name
end