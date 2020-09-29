module Shift

	def Shift.encode (shift, cypher_text, multiplier = 1)
		cypher_text.upcase!
		cypher_array = cypher_text.codepoints.to_a.collect{ |a| a-65 }
		
		plain_text = cypher_array.collect {|a| ((a*multiplier)+shift) }
		
		# Mod
		plain_text.collect! {|a| a % 26 }
		
		# Convert to characters
		plain_text = plain_text.collect{ |a| a+65 }
		plain_text = plain_text.pack('C*')
		
		plain_text
	end
	
	def Shift.decode (shift, cypher_text, inverse = 1)
	
	#	inverse = modInverse(multiplier, 26)
		
		cypher_text.upcase!
		cypher_array = cypher_text.codepoints.to_a.collect{ |a| a-65 }

		# Shift
		plain_text = cypher_array.collect {|a| ((a-shift)*inverse) }
		
		# Mod
		plain_text.collect! {|a| a % 26 }
		
		# Convert to characters
		plain_text = plain_text.collect{ |a| a+65 }
		plain_text = plain_text.pack('C*')
		
		plain_text
	end
	
	def Shift.extended_gcd(a, b)
		return [0,1] if a % b == 0
		x,y = extended_gcd(b, a % b)
		[y, x-y*(a / b)]
	end
	
	def Shift.modInverse(a, m)
		a = a % m
		
		(1..m).each do |x|
			return x if ( (a*x) % m == 1 )
		end
		
		raise Exception, "Couldn't find a modular inverse for #{a} % #{m}"
	end
	
end
