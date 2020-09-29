# 
# Transposition cipher cracker 
# 
# Algorithm used to find keys: 
# 
# n = keylength 
# t = textlength 
# a = t / n 
# b = t % n 
# d = accumulated rest terms 
# k = wanted plain text position 
# loc(k) = a * perm(k % n) + d(perm(k % n)) + k/n 
# 
# By Ben Ruijl, 2009 
# 
# compile: g++ -O2 col.cpp 
#/ 

Module Transposition

MAXKEY 20 

#const char* buffer = "irtyhockeibtdaamoelatcnsronhoniirttcacdeiunsihaioarnndgpruphahirgtoarnmclspstwe"
#int buflength
#const char* crib = "computer"
#int criblength

	def print( perm, n )
		a = buflength / n
		b = buflength % n

		#invert perm 
		invperm = []
		
		# Fill
		(0..n).each do |i|
			invperm[perm[i]] = i
		end
		
		int d[MAXKEY] = {0}
		(1..n).each do |i|
			d[i] = d[i - 1]	
			d[i]++ if (invperm[i - 1] < b) 
			
		end
		
		puts "Found: "
		
		(0..buflength).each do |i|
			puts buffer[a * perm[i % n] + d[perm[i % n]] + i / n]
		end
	end 


	def checkperm(perm, n) 
		cribpos = 0
		a = buflength / n
		b = buflength % n

		#invert perm 
		invperm = []

		(0..n).each do |i|
			invperm[perm[i]] = i
		end
		
		d = []
		(1..n).each do |i|
			d[i] = d[i - 1]
			d[i]++ if (invperm[i - 1] < b)
		end


		(0..buflength).each do |i|
			if (buffer[a * perm[i % n] + d[perm[i % n]] + i / n] == crib[cribpos]) 
				cribpos++
			else 
				cribpos = 0
			end

			if (cribpos == criblength)
				Transposition.print(perm, n) # print the found text 
				return true
			end
		end

		return false
	end

# University of Exeter algorithm 
# a fast algorithm, we don't care about sorting it like a dictionary 
	def permute(v, start, n) 
		if (start == n - 1) 
			checkperm(v, n)
		else
			(start..n).each do |i|
				tmp = v[i]
				v[i] = v[start]
				v[start] = tmp
				permute(v, start + 1, n)
				v[start] = v[i]
				v[i] = tmp
			end
		end
	end

int main(int argv, char** argc) 
{ 
int perm[MAXKEY]

for (int i = 0i < MAXKEYi++) 
perm[i] = i

buflength = strlen(buffer)
criblength = strlen(crib)

int curkey = 2# start key 

while (curkey < MAXKEY) 
{ 
puts "Testing key " << curkey << std::endl
permute(perm, 0, curkey)# permutate keys 
curkey++
} 

return 0
}
end