=begin rdoc
Examples of the different syntax version of the fixme/and todo-command.
=end
$:.unshift('../lib')
require 'todonotes'

#a ToDo with default text 'ToDo' and without temporary result
to do 
  "my temporary result"
end

#a ToDo without temporary result
todo "my description of the missing code"

#a ToDo without description, but a temporary result
todo { "my temporary result" }

#a ToDo with description and temporary result
todo ('my description of the missing code' ) { "my temporary result" }


#a ToDo without description, but a temporary result
todo do
  "my temporary result"
end

#a ToDo with description and temporary result
todo 'Text' do
  "my temporary result"
end

####################

#a FixMe without description, but a temporary result
fixme { "my temporary result" }

#a FixMe with description and temporary result
fixme ('my description if the wrong code' ) { "my temporary result" }

#a FixMe without description, but a temporary result
fixme do
  "my temporary result"
end

#a FixMe with description and temporary result
fixme 'my description if the wrong code' do
  "my temporary result"
end
####################
#a Fixme is called twice
2.times { fixme "my description of the missing code" }
#a ToDo is called three times
3.times { todo  "my description of the missing code" }

####################

#Get an overview of all ToDos and FixMes
Todonotes.print_stats
