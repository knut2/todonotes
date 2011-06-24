$:.unshift('../lib')
require 'todonotes'

#
#
Todonotes.instance.logger.level = Log4r::WARN #only first time of callinf a fixme/todo
Todonotes.instance.logger.level = Log4r::INFO   #report all calls of fixme/todo

class Fixnum
  def prime?
      fixme "Calculate if prime" do 
              self.odd?  #tempory: odd = prim
      end    
  end
end

primecount = 0
for i in 1..10
        if i.prime?
          primecount += 1 
          puts "#{i} is a prime number"
        else
          puts "#{i} is no prime number"
        end
end

todo "Return total number of primes"

#Details
Todonotes.print_stats()


