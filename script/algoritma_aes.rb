def encrypt_aes(plaintext, key)
  key = key.slice(0, 32)
  cipher = OpenSSL::Cipher.new('AES-256-ECB')
  cipher.encrypt
  cipher.key = key
  ciphertext = cipher.update(plaintext) + cipher.final
  Base64.encode64(ciphertext)
end

def decrypt_aes(ciphertext, key)
  key = key.slice(0, 32)
  decipher = OpenSSL::Cipher.new('AES-256-ECB')
  decipher.decrypt
  decipher.key = key
  decipher.update(Base64.decode64(ciphertext)) + decipher.final
end