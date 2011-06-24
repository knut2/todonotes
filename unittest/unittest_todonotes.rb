gem 'test-unit'
require 'test/unit'

$:.unshift('../lib')
require 'todonotes'

=begin rdoc
Define a new outputter to catch data into an array
=end
class ArrayOutputter < Log4r::StdoutOutputter
=begin rdoc
Collect messages in array.
=end
  def write(message)
    @messages ||= []  #create with first call
    @messages  << message
  end
=begin rdoc
Clear message array and return messages
=end
  def flush
    @messages ||= []  #create with first call
    messages = @messages.dup
    @messages.clear
    messages
  end
end #ArrayOutputter

#~ Todonotes.instance.logger.level = Log4r::OFF  #No logging
Todonotes.instance.logger.outputters.first.level = Log4r::OFF
Todonotes.instance.logger.outputters << $testlog = ArrayOutputter.new('testlog')
$testlog.formatter = Log4r::FixmeFormatter.new

class Test_syntax < Test::Unit::TestCase
  def test_todo()
    assert_nothing_raised{
      to do 
        "mein Ergebnis"
      end
    }
    assert_nothing_raised{
      todo "mein Text"
    }
    assert_nothing_raised{
      todo { "mein Ergebnis" }
    }
    assert_nothing_raised{
      todo ('mein Text' ) { "mein Ergebnis" }
    }
    assert_nothing_raised{
      todo do
        "mein Ergebnis"
      end
    }
    assert_nothing_raised{
      todo 'Text' do
        "mein Ergebnis"
      end    
    }
  end
  def test_fixme
    assert_nothing_raised{
      fixme "mein Text"
    }
    assert_nothing_raised{
      fixme { "mein Ergebnis" }
    }
    assert_nothing_raised{
      fixme ('mein Text' ) { "mein Ergebnis" }
    }
    assert_nothing_raised{
      fixme do
        "mein Ergebnis"
      end
    }
    assert_nothing_raised{
      fixme 'Text' do
        "mein Ergebnis"
      end    
    }
  end
  #~ def test_print_stats
    #~ assert_nothing_raised{ print_stats }
  #~ end  
end

class Test_value_and_log < Test::Unit::TestCase
  def setup()
    $testlog.flush
  end
  
  def test_todo()
    assert_equal("mein Ergebnis", todo() { "mein Ergebnis" } )
    assert_equal(["ToDo : #{__FILE__}:#{__LINE__ - 1} ToDo (temporary: \"mein Ergebnis\")\n"], $testlog.flush )
    
    assert_equal("mein Ergebnis", todo( 'text' ){"mein Ergebnis"} )
    assert_equal(["ToDo : #{__FILE__}:#{__LINE__ - 1} text (temporary: \"mein Ergebnis\")\n"], $testlog.flush )
    
    assert_equal(nil, todo( "my text"))
    assert_equal(["ToDo : #{__FILE__}:#{__LINE__ - 1} my text (temporary: nil)\n"], $testlog.flush )
        
  end
  def test_fixme
    assert_equal("mein Ergebnis", fixme() {"mein Ergebnis"} )
    assert_equal(["FixMe: #{__FILE__}:#{__LINE__ - 1} FixMe (temporary: \"mein Ergebnis\")\n"], $testlog.flush )
    
    assert_equal("mein Ergebnis", fixme( 'text' ){"mein Ergebnis"} )
    assert_equal(["FixMe: #{__FILE__}:#{__LINE__ - 1} text (temporary: \"mein Ergebnis\")\n"], $testlog.flush )
    
    assert_equal(nil, fixme( "my text"))
    assert_equal(["FixMe: #{__FILE__}:#{__LINE__ - 1} my text (temporary: nil)\n"], $testlog.flush )
  end
end

class Test_overview < Test::Unit::TestCase
  def test_overview()
    Todonotes.instance.codeline.clear
    
    #check empty fixme/todo
    text = "List of ToDos/FixMes:"
    codeline = {}
    assert_equal(text, Todonotes.instance.overview())
    assert_equal(codeline, Todonotes.instance.codeline)
    
    line = __LINE__; fixme('a')
    text << "\n#{__FILE__}:#{line}:    1 call"
    codeline["#{__FILE__}:#{line}"] = 1
    assert_equal(text, Todonotes.instance.overview())
    assert_equal(codeline, Todonotes.instance.codeline)
    
    #Add 2nd todo
    line = __LINE__; fixme('b')
    text << "\n#{__FILE__}:#{line}:    1 call"
    codeline["#{__FILE__}:#{line}"] = 1
    assert_equal(text, Todonotes.instance.overview())
    assert_equal(codeline, Todonotes.instance.codeline)
    
    #check plural-s in calls
    line = __LINE__; 2.times{ fixme('c') }
    text << "\n#{__FILE__}:#{line}:    2 calls"
    codeline["#{__FILE__}:#{line}"] = 2
    assert_equal(text, Todonotes.instance.overview())
    assert_equal(codeline, Todonotes.instance.codeline)
  end
end

class Test_log_with_file < Test::Unit::TestCase
  @@logfilename = 'test.log'
  @@logfilename_default = File.basename($0) + '.todo'
  def setup()
    File.delete(@@logfilename) if File.exist?(@@logfilename)
    File.delete(@@logfilename_default) if File.exist?(@@logfilename_default)
  end
  def teardown()
    File.delete(@@logfilename) if File.exist?(@@logfilename)
    File.delete(@@logfilename_default) if File.exist?(@@logfilename_default)
  end
  def test_logfile()
    assert_false(File.exist?(@@logfilename))
    Todonotes.instance.log2file(@@logfilename)
    assert_equal(@@logfilename, Todonotes.instance.logger.outputters.last.filename)
    assert_true(File.exist?(@@logfilename))
    Todonotes.instance.logger.outputters.last.close #
    Todonotes.instance.logger.outputters.pop  #
  end
  def test_logfile_default()
    assert_false(File.exist?(@@logfilename_default))
    Todonotes.instance.log2file() #no filename
    assert_equal(@@logfilename_default, Todonotes.instance.logger.outputters.last.filename)
    assert_true(File.exist?(@@logfilename_default))
    Todonotes.instance.logger.outputters.last.close #
    Todonotes.instance.logger.outputters.pop  #
  end
end


__END__
