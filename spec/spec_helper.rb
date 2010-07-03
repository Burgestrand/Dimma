$:.unshift File.dirname(__FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)
require 'dimma'
require 'spec'
require 'webmock/rspec'

Spec::Runner.configure do |config|
  config.include WebMock
end