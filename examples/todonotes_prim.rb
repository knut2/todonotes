$:.unshift('../lib')
require 'todonotes'

#
#
Todonotes.instance.logger.level = Log4r::WARN #only first time of callinf a fixme/todo
Todonotes.instance.logger.level = Log4r::INFO   #report all calls of fixme/todo

primecount = 0
for i in 1..10
        if fixme "Calculate if prime" do 
              i.odd?  #tempory: odd = prim
            end
          primecount += 1 
          puts "#{i} is a prime number"
        else
          puts "#{i} is no prime number"
        end
end

todo "Return total number of primes"

#Details
Todonotes.print_stats()

