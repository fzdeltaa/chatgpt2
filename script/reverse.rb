alphabet = 'abcdefghijklmnopqrstuvwxyz'

def encryptReverse(plaintext, alphabet)
  ciphertext = ''

  plaintext.each_char do |x|
    temp = x.downcase
    index = alphabet.index(temp)
    if index
      newChar = alphabet.reverse[index]
      if temp.upcase == x
        newChar = newChar.upcase
      end
      ciphertext += newChar
    else
      ciphertext += x
    end
  end
  puts ciphertext
end
