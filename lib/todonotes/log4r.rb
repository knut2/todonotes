module Todonotes
=begin rdoc
Define a formatter.
=end
class FixmeFormatter < Log4r::BasicFormatter
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
end #module Todonotes
