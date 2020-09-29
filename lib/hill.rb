require 'matrix'
require 'rational'

module Hill

  def Hill.encode_numbers(key, number_array, mod = 256)

    cipher_text = []

    i = 0

    while i < number_array.length-1 do
      cipher_chars = (key * Matrix.column_vector([number_array[i], number_array[i+1]])).to_a.flatten.collect{|a| a % mod}

      cipher_text << cipher_chars

      i += 2
    end

    cipher_text.collect{|a| a.pack('C*')}.flatten
  end

  def Hill.decode_numbers(key, number_array, mod = 256)

    inverse = key.inverse
    det = key.determinant

    begin
      det_inverse = invert(det, mod)
    rescue ZeroDivisionError => e
      return
    end

    decode_key = (det_inverse * inverse).collect{ |a| a % mod }

    encode_numbers(decode_key, number_array)

  end

  def Hill.encode_ascii(key, plain_text)

    number_array = plain_text.codepoints.to_a

    encode_numbers(key, number_array, 256)

  end

  def Hill.encode_letters(key, plain_text)

    number_array = plain_text.codepoints.to_a.collect{ |a| a-65 }

    encode_numbers(key, number_array, 26)

  end

  def Hill.decode_letters(key, cipher_text)

    number_array = cipher_text.codepoints.to_a.collect{ |a| a-65 }

    decode_numbers(key, number_array, 26)

  end

  def Hill.find_keys(known_text, cipher_text, mod = 256)

=begin
    # We're going to try all possible sizes for keys (ie, 2x2, 3x3, 4x4)
    (4..[4, Math.sqrt(known_text)].max).each do |n|
      # While we can, until we find a key or run out of characters,
      # We're going to keep shifting down the known_text.

      matrix = letters_to_matrix(known_text.slice(0, n))

    end
=end

    #

    known_text = known_text.codepoints.to_a.collect{ |a| a-65 }
    cipher_text = cipher_text.codepoints.to_a.collect{ |a| a-65 }

    till = known_text.size - 4

    #a, b, c, d = 0
    (0..till).each do |i|

      plain_pair1 = [known_text[i], known_text[i+1]]
      cipher_pair1 = [cipher_text[i], cipher_text[i+1]]

      plain_pair2 = [known_text[i+2], known_text[i+3]]
      cipher_pair2 = [cipher_text[i+2], cipher_text[i+3]]

      # -      -   -      -   -    -
      # | a, b |   | p1.1 |   | c1 |
      # |      | . |      | = |    |
      # | c, d |   | p1.2 |   | c2 |
      # -      -   -      -   -    -
      # Solving for 'a'

      coefficients = [plain_pair1, plain_pair2].collect! do |row|
        row.collect! { |x| Rational(x) }
      end
      coefficients = Matrix[*coefficients]
      constants = Matrix[[Rational(cipher_pair1[0])], [Rational(cipher_pair2[0])]]

      solutions = coefficients.inverse * constants
      puts solutions

      a = solutions[0, 0]
      b = solutions[0, 0]
=begin

      congruence_ab_1 = "#{plain_pair1[0]}a + #{plain_pair1[1]}b = #{cipher_pair1[0]}"
      congruence_cd_1 = "#{plain_pair1[0]}c + #{plain_pair1[1]}d = #{cipher_pair1[1]}"


      congruence_ab_2 = "#{plain_pair2[0]}a + #{plain_pair2[1]}b = #{plain_pair2[0]}"
      congruence_cd_2 = "#{plain_pair2[0]}c + #{plain_pair2[1]}d = #{plain_pair2[1]}"

      puts congruence_ab_1
      puts congruence_ab_2

      # Solving for a
      congruence_1a = congruence_2a = plain_pair1[0] * plain_pair2[0]
      congruence_1a = congruence_2a = plain_pair1[0] * plain_pair2[0]

      pair2_a = plain_pair2[0] * plain_pair1[1]

      congruence_ab_1 = "#{congruence_1a}a + #{plain_pair1[1]}b = #{cipher_pair1[0]}"
      congruence_ab_2 = "#{congruence_2a}a + #{plain_pair2[1]}b = #{plain_pair2[0]}"

      puts congruence_ab_1
      puts congruence_ab_2

=begin
      pair_a = pair1_a - pair2_a

      a_value = (cipher_pair1[0] * plain_pair2[0]) - (cipher_pair2[0] * plain_pair1[0])

      begin
        a_inverse = Hill.invert(pair_a, 26)
      rescue ZeroDivisionError => e
        next
      end

      a_value = a_value/a_inverse

      puts a_value
=end
    end
  end

  def Hill.letters_to_matrix(letters)
    letters = letters.split(//) unless letters.is_a? Array

    cols = []
    n2 = [4, Math.sqrt(known_text)].max

    (0..n2).each do |i|
      cols << letters.slice(i*n2, n2)
    end

    Matrix.column_vector(cols)
  end

  private

  def Hill.invert(num, mod)
    g, a = extended_gcd(num, mod)
    unless g == 1
      raise ZeroDivisionError.new("#{num} has no inverse modulo #{mod}")
    end
    a % mod
  end

  def Hill.extended_gcd(a, b)
    return [0,1] if a % b == 0
    x,y = extended_gcd(b, a % b)
    [y, x-y*(a / b)]
  end

  def Hill.modInverse(a, m)
    a = a % m

    (1..m).each do |x|
      return x if ( (a*x) % m == 1 )
    end

    raise Exception, "Couldn't find a modular inverse for #{a} % #{m}"
  end
end
