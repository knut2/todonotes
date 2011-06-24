$:.unshift('../lib')
require 'todonotes'

to do 
  "mein Ergebnis"
end

todo "mein Text"

todo { "mein Ergebnis" }

todo ('mein Text' ) { "mein Ergebnis" }

todo do
  "mein Ergebnis"
end

todo 'Text' do
  "mein Ergebnis"
end

####################
2.times { fixme "mein Text" }

fixme { "mein Ergebnis" }

fixme ('mein Text' ) { "mein Ergebnis" }

fixme do
  "mein Ergebnis"
end

fixme 'Text' do
  "mein Ergebnis"
end
####################

Todonotes.print_stats
