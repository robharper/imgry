begin
  require 'bundler'
  Bundler.setup(:default, :development)
rescue LoadError => e
  # Fall back on doing an unlocked resolve at runtime.
  $stderr.puts e.message
  $stderr.puts "Try running `bundle install`"
  exit!
end

require 'pathname'

$:.unshift(File.dirname(__FILE__))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
IMGRY_ROOT = Pathname.new(File.expand_path('../../', __FILE__))
SPEC_ROOT = IMGRY_ROOT.join('spec')

begin
  require 'pry'
  require 'pry-nav'
rescue LoadError
end

require 'imgry'
require 'rspec'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
# Dir["#{SPEC_ROOT}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec  
end
