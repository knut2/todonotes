module Todonotes
=begin rdoc
Report the ToDo/FixMe and count occurence.

The first occurence is reported as a warning, 
next occurences are informations.
=end
  class Todo
=begin rdoc



=end
    def initialize(codeline, type, comment, logger, &block)
      @logger = logger
      @count = 1
      @codeline = codeline
      @type = type
      @shortdescription = comment      
      #Build result
      @result = yield if block_given?
      
      @logger.warn([@type, "#{@codeline} #{@shortdescription} (temporary: #{@result.inspect})"])

    end
    #Temporary result of the Todo. This result should become a 'real' value
    attr_reader :result
    attr_reader :short_description
    attr_reader :count
=begin rdoc
Todo/Fixme is called again  
=end
    def call()
      @logger.info([@type, "#{@codeline}(#{@count}) #{@shortdescription} (temporary: #{@result.inspect})"])
      @count += 1
    end
=begin rdoc
=end    
    def to_s()
      "#{@type}: #{@codeline}"  
    end
=begin rdoc
Return a single line with status of the todo.

Depending on with_type you get also the type (ToDo/FixMe)
=end    
    def infoline(settings)
      res = @codeline.dup
      res << " (%-5s)" % @type if settings.include?(:with_type)
      res << ": %4i call%s" % [ 
            @count, @count > 1 ? 's': ''  
        ]
      res << " (%s)" % @shortdescription if settings.include?(:with_shortdescription)
      res << " = '#{@result.inspect}'" if settings.include?(:with_result)
      res
    end #info
  end #class Codeline
end #module Todonotes
