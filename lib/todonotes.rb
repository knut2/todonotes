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

=begin rdoc
Define a formatter.
=end
class Log4r::FixmeFormatter < Log4r::BasicFormatter
=begin rdoc
If event is an Array, the output is adapted.

This outputter is only for internal use via Todonotes.
=end
    def format(event)
      #@@basicformat      "%*s %s"
      #~ buff = sprintf("%-*s %-5s", Log4r::MaxLevelLength, Log4r::LNAMES[event.level],
             #~ event.data.is_a?(Array) ? event.data.first : event.name)
      buff = "%-5s" % (event.data.is_a?(Array) ? event.data.first : event.name)
      #~ buff += (event.tracer.nil? ? "" : "(#{event.tracer[2]})") + ": "
      buff << ": "
      buff << format_object(event.data.is_a?(Array) ? event.data.last : event.data) 
      buff << (event.tracer.nil? ? "" : " (#{event.tracer.join('/')})")
      buff << "\n"
      buff
    end
end

=begin rdoc
Singleton definition for a fixme.

You can use Fixme#instance to set some global settings:
* FiXme#log2file Define log file
* FiXme#logger adapt level, outputter ...
* FiXme#codelines get Hash with counter per ToDo-locations.
* FiXme#overview get overview text with ToDo-locations.
=end
class Todonotes
  VERSION = '0.1.1.beta'
  include Singleton
=begin rdoc
Define the singleton-instance.
=end
  def initialize()
    # @codelines is a Hash with Filename and codelines (key). Value is the number of calls.
    @codelines = Hash.new(0)
    @logger = Log4r::Logger.new('ToDo')
    @logger.outputters = Log4r::StdoutOutputter.new('ToDo', 
                                    :level => Log4r::ALL,
                                    :formatter => Log4r::FixmeFormatter 
                                  )
    #~ @logger.trace = true
  end
  #Get logger to define alternative outputters...
  attr_reader :logger
=begin rdoc
Write the todo's in a logging file.

Default filename is $0.todo
=end
  def log2file(filename = File.basename($0) + '.todo', level = Log4r::ALL)
    @logger.add( Log4r::FileOutputter.new('ToDo', 
                                    :filename => filename,
                                    :level => level,
                                    :formatter => Log4r::FixmeFormatter 
                                  ))
    
  end
  #Direct access to the codelines list. See also #todo_overview
  attr_reader :codelines
=begin rdoc
Report a FixMe or a ToDo.

The comment is logged, 
the block is evaluated to get a temporary result.
=end
  def todo( comment, type = :ToDo, &block)
    res = nil
    key = caller[1].split(':in').first
    if block_given?
      res = yield self
      res
    end
    log_todo(key, type, comment, res)
    #~ @logger.debug("Return #{res.inspect} instead") if @logger.debug?
    res
  end
=begin rdoc
Report the ToDo/FixMe and count occurence.

The first occurence is reported as a warning, 
next occurences are informations.
=end
  def log_todo( key, type, text, res )

    @codelines[key] += 1
    if @codelines[key] == 1 #First occurence?
      @logger.warn([type, "#{key} #{text} (temporary: #{res.inspect})"])
    else  #Erste auftauchen
      @logger.info([type, "#{key}(#{@codelines[key]}) #{text} (temporary: #{res.inspect})"])
    end
  end
  
=begin rdoc
Return a text to be printed
  puts Todonotes.instance.todo_overview()
Used from Todonotes.print_stats

Example:
  List of ToDos/FixMes:
  fixme.rb:195:    1 call
  fixme.rb:198:    2 calls
  fixme.rb:199:    1 call
  fixme.rb:200:    1 call
=end
  def overview( )
    txt = []
    txt << "List of ToDos/FixMes:"
    @codelines.each do |key, messages|
      txt << "%s: %4i call%s" % [ key, messages, messages > 1 ? 's': ''  ]
    end
    txt.join("\n")
  end

=begin rdoc
Class methods
=end
  class << self
=begin rdoc
See Todonotes#overview
=end
    def print_stats()
      puts Todonotes.instance.overview()
    end
=begin rdoc
See Todonotes#overview
=end
    def overview()
      Todonotes.instance.overview()
    end
=begin rdoc
See Todonotes#codelines
=end
    def codelines()
      Todonotes.instance.codelines()
    end
=begin rdoc
See Todonotes#logger
=end
    def logger()
      Todonotes.instance.logger()
    end
=begin rdoc
See Todonotes#log2file
=end
    def log2file(filename = File.basename($0) + '.todo', level = Log4r::ALL)
      Todonotes.instance.log2file(filename, level)
    end
  end #<< self
end

=begin rdoc
Define todo-commands to global usage.
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
    Todonotes.instance.todo(comment, &block)
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
    Todonotes.instance.todo(comment, :FixMe, &block)
  end  
end

if $0 == __FILE__
  todo( 'a' ){  
    "result" 
  }
  2.times{todo { "result" }}
  fixme { "result" }
  to('a') 
  #~ Todonotes.print_stats( )
  puts Todonotes.overview( )
  puts Todonotes.codelines( )
end