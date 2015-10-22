#encoding: utf-8
=begin rdoc
=Changes
Based on a proposal in http://forum.ruby-portal.de/viewtopic.php?f=11&t=11957, 
See also http://stackoverflow.com/a/13668213/676874

0.1.0 2011-06-24: 
* Initial version, copied from todo_gem

0.1.1 2012-12-02
* correction in documentation
* example in English
* Todonotes#codeline -> Todonotes#codelines
* Implement module Todonotes with methods overview, codelines, logger, log2file

See also 
* http://stackoverflow.com/questions/13668068/ruby-how-to-signal-not-implemented-yet
* http://stackoverflow.com/a/13668213/676874

0.1.2:
* Use Minitest
* Evaluate block for each call (allows dynamic results)
* raise NotImplementedError on request

0.2.0
* Adapted for ruby 2.1

0.2.1 2015-04-28 
* Adapted log4r-requirement (adapted Version)

0.2.2 2015-10-22
* Added license 'LGPL-3.0' http://opensource.org/licenses/LGPL-3.0
  https://github.com/knut2/todonotes/issues/1
=end
module Todonotes
  VERSION = '0.2.2'
end