module Cryptex
  ALPHABET = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".split('')

  def encrypt(num)
    return ALPHABET.first if num == 0

    encrypted_string = ''

    while num > 0
      encrypted_string << ALPHABET[num % 52]
      num /= 52
    end

    encrypted_string.reverse
  end

  def decrypt(string)
    id = 0

    string.split('').reverse.each_with_index do |c, i|
      id += (ALPHABET.index(c) * (ALPHABET.length ** i))
    end

    id
  end
end
