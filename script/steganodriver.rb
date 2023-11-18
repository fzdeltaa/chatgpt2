require 'chunky_png'
require_relative 'steganograte'
require_relative 'recoverate'

def encrypt_stegano(image, name)
  mask = ChunkyPNG::Image.from_file('./public/mask.png')
  mask.resample_bilinear!(image.width, image.height)
  Steganogrator.steganograte(mask, image, 8).save(name)
end

def decrypt_stegano(image, name)
  Steganogrator.recoverate(image, 8).save(name)
end