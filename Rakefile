require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new do |spec|
  spec.skip_bundler = true
end

require 'yard'
YARD::Rake::YardocTask.new

task :test => :spec
task :default => :spec