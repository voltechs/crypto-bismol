#!/usr/bin/env ruby

require 'optparse'

require './lib/vigenere'
require './lib/atbash'
require './lib/shift'
require './lib/wordify'
require './lib/hill'

COMMON_WORDS = open('words2.dic').map { |line| line.strip }
COMMON_WORDS.reject! { |c| c.empty? }


cipher1 = "ltardbtidrgneidadvnvpbtdc"
cipher2 = "442315 431513421544 4434 54344542 43451313154343 2443 232414141533 2433 54344542 1411243154 42344544243315"
cipher3 = "fivihasefeenrurthetiyisbtsiandgnhontselhouedfrsoigsant"
cipher4 = "AYRABXPAAKZPJVAXKPREWZAJXMAXCAVEDIAZMZQDPJPAJPAAYZAARWREDAQRAAREAXCAZAQZMNLZNRAYZPAZAIREPXMZQJADAZQQAJAPAXHM"
cipher5 = "sebdqbmsbrsdjnqyfljfvfldjfbrlnsflcmjjfldausflqfrfldbvbqysfkbwbcmjj"
cipher6 = "bcbqaoirntqibfkuiskoirntqibfkuisaiijubpkjqvaipispktsnpicktjwvabranpi
bjunpbnofyointsbctfnjwansisaiijubpkjqvaipirpkvwqkcliklfinpicktjwvabranpi
bjunpbnofythfyoirntqikcnffsaisifiubqbkjrkggiprbnfqrkresnbflnpsbiqnjwnqqkpsiw
qkrbnflkqstpbjhbsatqiqrnlioirntqibjnvkpfwvaipigkqsgijqiigskqlijwsaibp
fbuiqwkbjhvanssaiyansigycbqabjhbqnskjrinjijwfiqqqktprikcwifbhasnjwnjnrs
kcqgnffpioiffbkjoirntqispktswkjksfbikprainsnjwrnjjksoiokthaskpopboiwkp
bglpiqqiwoylkvipotspiqlkjwkjfyskmtbistwinjwatgbfbsynjwijwfiqqlnsbijri
oirntqibqtqlirssansgijnpihkbjhsabqvnyckpsaifnqssbginjwbckpkjiwkjsvnjs
skvnqsisaispbloirntqigiprbctffysaipinpijksifilakjiqkjspktsvnsipqoirntqibj
saivkkwqbrnjcbjwqkfbstwivbsaktsfkjifbjiqqnjwcbjnffyjksoirntqibpihnpw
cbqabjhnqoibjhqksippbofybglkpsnjsotsoirntqibqtqlirssansqkgnjykcsaiksaip
rkjripjqkcgijnpiimtnffytjbglkpsnjsnjwjksjinpfyqkgtractjoypkoipsspnuip"
cipher7 = "HYCFUYOIEWYUWKNDLPDYKMACCPDPBG"
plain7 = "IFTHISWASEASYEVE"

azzip = Vigenere.encode("BULLETS", "Welcome to Arnold's Pizza Shop!")

pizza = Vigenere.decode("BULLETS", azzip);
puts pizza

cipher = cipher5
#puts "Enter cipher text"
#gets cipher

puts "Hello"
puts Hill.encode_letters(Matrix[[6, 1], [3, 4]], "crypto")
puts "Goodbye"

keys = Hill.find_keys(plain7, cipher7, 26)
keys.each do |key|
	puts Hill.decode_letters(key, cipher7)
end

puts "Hello, world!"
dlrow = Hill.encode_letters(Matrix[[3, 3], [2, 5]], "Hello, world!")
#puts dlrow

puts Hill.decode_letters(Matrix[[3, 3], [2, 5]], dlrow)

=begin
puts "Decrypting: '#{cipher}'. Get to the choppa!"
puts "\nCipher Test: Shift Cipher"
(0..25).each do |shift|
	[1, 3, 5, 7, 9, 11, 15, 17, 19, 21, 23, 25].each do |multiplier|
		inverse = Shift.modInverse(multiplier, 26)
		print "\r#{shift}"+('.'*shift)
		decode = Shift.decode(shift, cipher, inverse).downcase!
		found = COMMON_WORDS.select{ |word| decode.include?(word) }
		found.sort_by!(&:length).reverse!
		
		if found.any?
			wordified = Wordify.filter(decode, found)
		
			# Only display results who has a word bigger than n letters.
			#if found.sort_by!(&:length).reverse!.first.size > 4
			puts "[shift: #{shift}, inverse: #{inverse} (#{multiplier} = 1 % 26)] => " + wordified.first.inspect if wordified.first[:score] > 0.5
		end
	end
end

print "\rCipher Test: Vigenere Square\n"

i = 0.0
t = 17576.0+COMMON_WORDS.size
key = ""
(COMMON_WORDS | ("a".upto("zzz")).to_a).each do |key|
	i += 1
	print "\r"+((i/t)*100).round(2).to_s+"% : "+key+(" "*(100-key.length))
	decode = Vigenere.decode(key, cipher)
	decode.downcase!
	
	found = COMMON_WORDS.select{ |word| decode.include?(word) }
	found.sort_by!(&:length).reverse!
	
	if found.any?
		wordified = Wordify.filter(decode, found)
	
		# Only display results who has a word bigger than n letters.
		#if found.sort_by!(&:length).reverse!.first.size > 4
		puts "\r[key: #{key}] => " + wordified.first.inspect if wordified.first[:score] > 0.5
	end
end

=begin
(0..26).each {|shift|

	shifted = shift_decrypt(cipher_n, shift)
	#atbash_decrypt(shifted)
}
=end
