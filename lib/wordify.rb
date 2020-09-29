module Wordify

	def Wordify.filter (text, wordlist)
		
		candidates = []
		new_text = ''
		
		# Don't bother if we're not beginning with a word.
		#if text.start_with?(wordlist)
		
			wordlist.each do |word|
				
				new_text = text.sub(/\A#{word}/, '')
				
				# Looks like we found the word in the string.
				if (new_text.length < text.length)
					new_candidates = Wordify.filter(new_text, wordlist)
					new_candidates.each do |candidate|
						candidate[:words].unshift(word)
						candidate[:score] = Wordify.score(candidate[:text], candidate[:words])
					end
					#candidates << candidate
					candidates |= new_candidates
					text = new_text
				end
			
			end
			
			candidates.sort_by! { |k| k[:score] }
			
			candidates.reverse!
		#end
		
		if candidates.any?
			return candidates
		else
			return [{:words => [], :score => Wordify.score(text, []), :text => text}]
		end
	end
	
	def Wordify.score(text, words)
		return (words.length * 1.0)/(words.length+text.length+1.0)
	end
	
end
