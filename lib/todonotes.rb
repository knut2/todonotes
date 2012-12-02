=begin rdoc
Define todo- and fixme-command.

Usage:
Add todo and fixme to your code and get track of your todos during 
runtime of your code.

When you pass a todo/fixme during execution, you get a logging information.


  todo ('message' ) { "temporary result" }
  fixme ('message' ) { "temporary result" }

todo and fixme have the same syntax, the sematic meaning is:
* ToDo: Mark missing code.
* FixMe: Mark code to repair.

Disadvantage:
* Does not replace a good IDE. 
  to see the ToDo/FixMe 

Gem based on a proposal in http://forum.ruby-portal.de/viewtopic.php?f=11&t=11957

=end

require 'singleton'
require 'log4r'

require_relative 'todonotes/todonotes'
require_relative 'todonotes/todo'
require_relative 'todonotes/log4r'
require_relative 'todonotes/kernel'

=begin rdoc
Module Todonotes.

Encapsuate:
* Todonotes::Todonotes (Singleton)
* Todonotes::FixmeFormatter
=end
module Todonotes
  VERSION = '0.1.1'
  #'singleton'-instance of Todonotes
  TODONOTES = Todonotes.new()
=begin rdoc
Define module-methods
=end
  class << self
    
=begin rdoc
See Todonotes::Todonotes#overview
=end
    def print_stats( with_type = false )
      TODONOTES.overview( with_type )
    end
=begin rdoc
See Todonotes::Todonotes#overview
=end
    def overview(*settings )
      TODONOTES.overview( *settings )
    end
=begin rdoc
See Todonotes::Todonotes#codelines
=end
    def codelines()
      TODONOTES.codelines()
    end
=begin rdoc
See Todonotes::Todonotes#logger
=end
    def logger()
      TODONOTES.logger()
    end
=begin rdoc
See Todonotes::Todonotes#log2file
=end
    def log2file(filename = File.basename($0) + '.todo', level = Log4r::ALL)
      TODONOTES.log2file(filename, level)
    end
  end #Todonotes-module mthods
end #module Todonotes


#Some testcode as "quick test"
if $0 == __FILE__
  
  todo( 'a' ){  
    "result" 
  }
  2.times{todo { "result" }}
  fixme { "result" }
  to('a') 
  #~ Todonotes.print_stats( )
  #~ puts Todonotes.overview( )
  #~ puts Todonotes.overview( :with_type )
  #~ puts Todonotes.overview( :with_type, :with_shortdescription )
  puts Todonotes.overview( :with_type, :with_shortdescription, :with_result )

  puts Todonotes.codelines( )
end
