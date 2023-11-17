def encrypt_reverse(plaintext)
  alphabet = 'abcdefghijklmnopqrstuvwxyz'
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
  ciphertext
end
