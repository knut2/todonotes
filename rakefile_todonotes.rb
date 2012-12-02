#Build todonotes-gem

#
#
require 'knut_tools/rake/gempackager'
require '../knut_pw.rb'

$:.unshift('lib')
require 'todonotes'

$todonotes_version = "0.1.2.pre"  

#http://docs.rubygems.org/read/chapter/20
rake4latexgem = Gem_packer.new('todonotes', $todonotes_version){ |gemdef, s|
  s.name = "todonotes"
  #major.minor.build  - see http://docs.rubygems.org/read/chapter/7
  s.version =  $todonotes_version
  s.author = "Knut Lickert"
  s.email = "knut@lickert.net"
  #~ s.homepage = "http://ruby.lickert.net/todonotes"
  s.homepage = "http://rubypla.net/todonotes"
  #~ s.rubyforge_project = 'todonotes'
  s.platform = Gem::Platform::RUBY
  s.summary = "Support programming by todonotes/todo commands."
  s.description = <<DESCR
todonotes.
Support programming by fixme/todo commands.

Gem based on a proposal in http://forum.ruby-portal.de/viewtopic.php?f=11&t=11957
DESCR
  s.require_path = "lib"
  s.files = %w{
readme.rdoc
lib/todonotes.rb
lib/todonotes/todonotes.rb
lib/todonotes/todo.rb
lib/todonotes/kernel.rb
lib/todonotes/log4r.rb
examples/todonotes_how_to.rb
examples/todonotes_prim.rb
examples/todonotes_prim2.rb
}
  s.test_files    = %w{
unittest/unittest_todonotes.rb
}
  #~ s.test_files   << Dir['unittest/expected/*']
  #~ s.test_files.flatten!

  #~ s.bindir = "bin"
  #~ s.executables << 'todonotes.exe'

  s.has_rdoc	= true  
  s.extra_rdoc_files = %w{
    readme.rdoc
  }
    #~ examples/todonotes_how_to.rb
    #~ examples/todonotes_prim.rb
    #~ examples/todonotes_prim2.rb
  s.rdoc_options << 'lib/**/*.rb' << '--main readme.rdoc' #<< '-f hanna'
  
  #~ s.add_development_dependency('more_unit_test', '> 0.0.2')  #assert_equal_filecontent
  s.add_dependency('log4r') 
  #~ s.requirements << 'Optional: A (La)TeX-system if used as TeX-generator (in fact, you can create TeX-Files, but without a TeX-System you will have no fun with it ;-))'

  gemdef.public = true
  gemdef.add_ftp_connection('ftp.rubypla.net', Knut::FTP_RUBYPLANET_USER, Knut::FTP_RUBYPLANET_PW, "/Ruby/gemdocs/todonotes/#{$todonotes_version}")


  gemdef.define_test( 'unittest', FileList['unittest*.rb'])
  gemdef.versions << Todonotes::VERSION

}

#~ task :hanna do
  #~ `gem rdoc todonotes -f hanna`
#~ end


task :hanna_local do
  FileUtils.rm_r('doc') if File.exist?('doc')
  `rdoc  -f hanna  #{rake4latexgem.spec.rdoc_options.join(" ")} #{rake4latexgem.spec.extra_rdoc_files.join(' ')}`
  #~ `rdoc -f hanna lib/**/*.rb readme.rdoc -m readme.rdoc `
end

desc "Default: :readme, :gem"
#~ task :default => :check
#~ task :default => :test
#~ task :default => :readme
#~ task :default => [ :gem ]
task :default => :hanna_local
#~ task :default => :hanna

#~ task :default => :install
#~ task :default => :links
#~ task :default => :ftp_rdoc
#~ task :default => :push



if $0 == __FILE__
  app = Rake.application
  app[:default].invoke
    #~ app[:test].invoke
  #~ app[:change_rakefiles].invoke
end


__END__
=Changes
0.1.0 2011-06-24: 
* Initial version, copied from todo_gem

0.1.1 2012-12-02
* correction in documentation
* example in English
* Todonotes#codeline -> Todonotes#codelines
* Implement module Todonotes with methods overview, codelines, logger, log2file

0.1.2:
* 
