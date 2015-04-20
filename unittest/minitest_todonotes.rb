gem 'minitest'
gem 'minitest-logger'
$:.unshift('c:/usr/script/minitest-logger/lib')

require 'minitest/autorun'
require 'minitest/log4r'

$:.unshift('../lib')
require 'todonotes'
Todonotes::TODONOTES.logger.outputters.first.level = Log4r::OFF #No visible logging output 

class Test_value_and_log < Minitest::Test
  def setup()
    @log = Todonotes::TODONOTES.logger
    @formatter = Todonotes::FixmeFormatter 
  end
  
  def test_todo_no_comment
    assert_equal("mein Ergebnis", todo() { "mein Ergebnis" } )
    assert_log(" ToDo: #{__FILE__}:#{__LINE__} ToDo (temporary: \"mein Ergebnis\")\n") {todo() { "mein Ergebnis" } }
  end
  def test_todo_comment_and_block
    assert_equal("mein Ergebnis", todo( 'text' ){"mein Ergebnis"} )
    assert_log(" ToDo: #{__FILE__}:#{__LINE__ } text (temporary: \"mein Ergebnis\")\n"){ todo( 'text' ){"mein Ergebnis"} }
  end
  def test_todo_no_block
    assert_equal(nil, todo( "my text"))
    assert_log(" ToDo: #{__FILE__}:#{__LINE__} my text (temporary: nil)\n"){ todo( "my text") }
  end
      
  def test_fixme_block_and_comment
    assert_equal("mein Ergebnis", fixme( 'text' ){ "mein Ergebnis"} )
    assert_log("FixMe: #{__FILE__}:#{__LINE__} text (temporary: \"mein Ergebnis\")\n"){ fixme( 'text' ){"mein Ergebnis"} }
  end
  def test_fixme_no_comment
    assert_equal("mein Ergebnis", fixme() {"mein Ergebnis"} )
    assert_log("FixMe: #{__FILE__}:#{__LINE__} FixMe (temporary: \"mein Ergebnis\")\n"){ fixme() {"mein Ergebnis"} }
  end
  def test_fixme_no_block
    assert_equal(nil, fixme( "my text"))
    assert_log("FixMe: #{__FILE__}:#{__LINE__} my text (temporary: nil)\n"){ fixme( "my text") }
  end
  
  def test_raise_fixme
    Todonotes::TODONOTES.raise_fixme = true
    assert_raises(NotImplementedError){ fixme }
    Todonotes::TODONOTES.raise_fixme = false  #reset again the default
  end
  def test_raise_todo
    Todonotes::TODONOTES.raise_todo = true
    assert_raises(NotImplementedError){ todo }
    Todonotes::TODONOTES.raise_todo = false  #reset again the default
  end
end

class Test_overview < Minitest::Test
  def setup()
    Todonotes::TODONOTES.codelines.clear
  end
=begin
Show if overview is:

  List of ToDos/FixMes:
  minitest_todonotes.rb:66:    1 call
  minitest_todonotes.rb:76:    1 call
=end
  def test_overview()
    #check empty fixme/todo
    text = "List of ToDos/FixMes:"
    codeline = []
    assert_equal(text, Todonotes::TODONOTES.overview())
    assert_equal(codeline, Todonotes::TODONOTES.codelines.keys)
    #Check class methods
    assert_equal(Todonotes.overview(), Todonotes::TODONOTES.overview())
    assert_equal(Todonotes.codelines, Todonotes::TODONOTES.codelines)

    line = __LINE__; fixme('a')
    text << "\n#{__FILE__}:#{line}:    1 call"
    codeline << "#{__FILE__}:#{line} (FixMe)"
    assert_equal(text, Todonotes::TODONOTES.overview())
    assert_equal(codeline, Todonotes::TODONOTES.codelines.keys)
    #Check class methods
    assert_equal(Todonotes.overview(), Todonotes::TODONOTES.overview())
    assert_equal(Todonotes.codelines, Todonotes::TODONOTES.codelines)
    
    #Add 2nd todo
    line = __LINE__; fixme('b')
    text << "\n#{__FILE__}:#{line}:    1 call"
    codeline << "#{__FILE__}:#{line} (FixMe)"
    assert_equal(text, Todonotes::TODONOTES.overview())
    assert_equal(codeline, Todonotes::TODONOTES.codelines.keys)
    #Check class methods
    assert_equal(Todonotes.overview(), Todonotes::TODONOTES.overview())
    assert_equal(Todonotes.codelines, Todonotes::TODONOTES.codelines)
  end #test_overview()
    
  def test_plural()
    #check plural-s in calls
    line = __LINE__; 2.times{ fixme('c') }
    assert_equal("List of ToDos/FixMes:\n#{__FILE__}:#{line}:    2 calls", Todonotes::TODONOTES.overview())
    assert_equal(["#{__FILE__}:#{line} (FixMe)"], Todonotes::TODONOTES.codelines.keys)
    #Check class methods
    assert_equal(Todonotes.overview(), Todonotes::TODONOTES.overview())
    assert_equal(Todonotes.codelines, Todonotes::TODONOTES.codelines)
  end

  def test_overview_with_type()
    
    line = __LINE__; fixme('a')
    
    assert_equal("List of ToDos/FixMes:\n#{__FILE__}:#{line} (FixMe):    1 call", 
            Todonotes::TODONOTES.overview(:with_type)
        )
    #Check class methods
    assert_equal(Todonotes.overview(), Todonotes::TODONOTES.overview())
    assert_equal(Todonotes.codelines, Todonotes::TODONOTES.codelines)
    
  end
  def test_overview_with_type_description()
    
    line = __LINE__; fixme('a')
    
    assert_equal("List of ToDos/FixMes:\n#{__FILE__}:#{line} (FixMe):    1 call (a)", 
        Todonotes::TODONOTES.overview(:with_type, :with_shortdescription)
      )

    #Check class methods
    assert_equal(Todonotes.overview(), Todonotes::TODONOTES.overview())
    assert_equal(Todonotes.codelines, Todonotes::TODONOTES.codelines)
    
  end  
  def test_overview_with_type_description_result()
    
    line = __LINE__; fixme('a'){2}
    
    assert_equal("List of ToDos/FixMes:\n#{__FILE__}:#{line} (FixMe):    1 call (a) = '2'", 
        Todonotes::TODONOTES.overview(:with_type, :with_shortdescription, :with_result)
      )

    #Check class methods
    assert_equal(Todonotes.overview(), Todonotes::TODONOTES.overview())
    assert_equal(Todonotes.codelines, Todonotes::TODONOTES.codelines)
    
  end   
end

class Test_log_with_file < Minitest::Test
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
    refute(File.exist?(@@logfilename))
    Todonotes::TODONOTES.log2file(@@logfilename)
    assert_equal(@@logfilename, Todonotes::TODONOTES.logger.outputters.last.filename)
    assert(File.exist?(@@logfilename))
    Todonotes::TODONOTES.logger.outputters.last.close #
    Todonotes::TODONOTES.logger.outputters.pop  #
  end
  def test_logfile_default()
    refute(File.exist?(@@logfilename_default))
    Todonotes::TODONOTES.log2file() #no filename
    assert_equal(@@logfilename_default, Todonotes::TODONOTES.logger.outputters.last.filename)
    assert(File.exist?(@@logfilename_default))
    Todonotes::TODONOTES.logger.outputters.last.close #
    Todonotes::TODONOTES.logger.outputters.pop  #
  end
end

__END__
