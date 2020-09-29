# TODO: Allow for any configuration of double letters. (Not just ij)
def polybius_decrypt( input, shift = 0 )
	alpha_list = %w[ a b c d e f g h ij k l m n o p q r s t u v w x y z ]
	shifted = alpha_list.shift(shift) if (shift != 0)
	alpha_list += shifted if (shift != 0)
	count = 0
	
	rowsfirst = {}
	colsfirst = {}
	(1..5).each do |row|
		(1..5).each do |col|

			rowsfirst_key = row.to_s + col.to_s
			colsfirst_key = col.to_s + row.to_s

			value = alpha_list[count]

			rowsfirst.merge!({rowsfirst_key => value})
			colsfirst.merge!({colsfirst_key => value})

			count += 1
		end
	end
	
	rowsfirst_decrypted = []
	colsfirst_decrypted = []
	
	input.split(' ').each do |crypted_word|
		numbers = crypted_word.scan(/../)
		rowsfirst_word = []
		colsfirst_word = []
		numbers.each do |number|
			rowsfirst_word << rowsfirst[number]
			colsfirst_word << colsfirst[number]
		end
		
		rowsfirst_decrypted << rowsfirst_word.join()
		colsfirst_decrypted << colsfirst_word.join()
	end
	
	puts "Polybius Square of #{shift}:\n\t" + rowsfirst_decrypted.join(" ")
	puts "Polybius Square of #{shift}:\n\t" + colsfirst_decrypted.join(" ")
end