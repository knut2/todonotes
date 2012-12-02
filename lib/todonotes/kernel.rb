=begin rdoc
Define todo- and fixme commands to global usage.
=end
module Kernel
=begin rdoc
Usage 1 (only message):
  todo "my todo-message""

Usage 2 (only temporary result):
  todo { "temporary result" }
  todo do
    "temporary result"
  end

Usage 3(message and temporary result):
  todo ('message') { "temporary  result" }
  todo ('message') do
    "temporary result"
  end

=end
  def todo( comment = 'ToDo', &block)
    Todonotes::TODONOTES.todo(comment, &block)
  end
=begin rdoc
Usage:
  to do 
    :result
  end
=end
  alias :to :todo
=begin rdoc
Add a fixme-command.

Can be used to mark available code.
=end
  def fixme( comment = 'FixMe', &block)
    Todonotes::TODONOTES.todo(comment, :FixMe, &block)
  end    
end #module Kernel
