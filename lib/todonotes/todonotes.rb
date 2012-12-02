module Todonotes
=begin rdoc
Collection of todos and fixmes.

The module Todonotes defines a 'singleton'-like 
Todonotes::TODONOTES to collect all todo/fixme from Kernel.

You can set settings with 
* Todonotes::Todonotes#log2file Define log file
* Todonotes::Todonotes#logger adapt level, outputter ...
* Todonotes::Todonotes#codelines get Hash with counter per ToDo-locations.
* Todonotes::Todonotes#overview get overview text with ToDo-locations.
=end
class Todonotes

=begin rdoc
Define the singleton-instance.
=end
  def initialize()
    @codelines = Hash.new()
    
    @logger = Log4r::Logger.new('ToDo')
    @logger.outputters = Log4r::StdoutOutputter.new('ToDo', 
                                    :level => Log4r::ALL,
                                    :formatter => FixmeFormatter 
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
                                    :formatter => FixmeFormatter 
                                  ))
    
  end
  #Direct access to the codelines list. See also #overview
  #Accessible via Todonotes::Todonotes.instance.codelines()
  attr_reader :codelines
=begin rdoc
Report a FixMe or a ToDo.
Create a Todonotes::Todo

The block is evaluated to get a temporary result.
=end
  def todo( comment, type = :ToDo, &block)
    codeline = caller[1].split(':in').first
    codelinekey = "#{codeline} (#{type})"

    if @codelines[codelinekey] #2nd or more calls
      @codelines[codelinekey].call
    else #First occurence?
      @codelines[codelinekey] = Todo.new(codeline, type, comment, @logger, &block)
    end 
    @codelines[codelinekey].result
  end #todo
  
=begin rdoc
Return a text to be printed
  puts Todonotes.overview()
Used from Todonotes.print_stats

Example:
  List of ToDos/FixMes:
  todonotes.rb:230:    1 call
  todonotes.rb:233:    2 calls
  todonotes.rb:234:    1 call
  todonotes.rb:235:    1 call

You may extend the output by parameters:
* :with_type
* :with_shortdescription
* :with_result

Example :with_type:
  todonotes.rb:230 (ToDo):    1 call
  todonotes.rb:233 (ToDo):    2 calls
  todonotes.rb:234 (FixMe):    1 call
  todonotes.rb:235 (ToDo):    1 call
=end
  def overview( *settings )
    txt = []
    txt << "List of ToDos/FixMes:"
    @codelines.each do |key, todo|
      txt << todo.infoline(settings)
    end
    txt.join("\n")
  end
end #class Todonotes
end #module Todonotes
