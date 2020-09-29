# AtBash Cipher
# 
# encode/decode any string using the AtBash Cipher method.
# 
# Usage:
#	 AtBash.encode('AtBash') #=> "AtBash"
#	 AtBash.encode('AtBash') #=> "TRVJRI"
#
#	 AtBash.decode('AtBash') #=> "AtBash"
#	 AtBash.decode('TRVJRI') #=> "AtBash" 
# 

module AtBash

	def AtBash.encode(cipher_text)
		# TODO
	end

	def AtBash.decode(cipher_text)
	
		keys = ('A'..'Z').to_a
		key = Hash[keys.zip(keys.reverse)]
		plain_text = cipher_text.collect { |a| key[a] }

	end
end
