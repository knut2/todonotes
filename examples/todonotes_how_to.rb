=begin rdoc
Examples of the different syntax version of the fixme/and todo-command.
=end
$:.unshift('../lib')
require 'rake'
require 'todonotes'

#Decide if we want to get only the first or all
Todonotes.logger.level = Log4r::WARN #only first time of callinf a fixme/todo
Todonotes.logger.level = Log4r::INFO   #report all calls of fixme/todo
#~ Todonotes::TODONOTES.raise_fixme = true #Throw exception if a fixme is evaluated
#~ Todonotes::TODONOTES.raise_todo = true #Throw exception if a todo is evaluated


desc "Show examples of todo-command"
task :todo do
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
end

####################
desc "Show examples of fixme-command"
task :fixme do
  #a FixMe without result, but a description
  fixme( "something is missing" )
  
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
end

desc "Show example of repetion of fixme-commands"
task :loops do
  ####################
  #a Fixme is called twice
  2.times { fixme "my first description of the missing code" }
  #a ToDo is called three times
  3.times { todo  "my second description of the missing code" }
  
  3.times { |i| todo  "my %i call" % i }
end
####################

desc "Show example of print_stats"
task :stat do
  puts "=========Exampe Statistic========="
  #Get an overview of all ToDos and FixMes
  puts Todonotes.print_stats
end

=begin
=end

#~ task :default => :todo
#~ task :default => :fixme
task :default => :loops
#~ task :default => :stat

if $0 == __FILE__
  Rake.application[:default].invoke
end