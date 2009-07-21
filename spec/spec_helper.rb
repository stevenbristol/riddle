$:.unshift File.dirname(__FILE__) + '/../lib'

require 'riddle'
require 'spec'
require 'spec/sphinx_helper'

Spec::Runner.configure do |config|
  sphinx = SphinxHelper.new
  sphinx.setup_mysql
  sphinx.generate_configuration
  sphinx.index
  
  config.before :all do
    `php -f spec/fixtures/data_generator.php`
    sphinx.start
  end
  
  # config.before :each do
  #   sphinx.reset
  # end
  
  config.after :all do
    sphinx.stop
  end
end

def query_contents(key)
  contents = open("spec/fixtures/data/#{key.to_s}.bin") { |f| f.read }
  contents.respond_to?(:encoding) ?
    contents.force_encoding('ASCII-8BIT') : contents
end
