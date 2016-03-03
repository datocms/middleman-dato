require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

require 'rubocop/rake_task'
RuboCop::RakeTask.new

desc 'Open an irb (or pry) session preloaded with this gem'
task :console do
  begin
    require 'pry'
    gem_name = File.basename(Dir.pwd)
    sh %(pry -I lib -r #{gem_name}.rb)
  rescue LoadError => _
    sh %(irb -rubygems -I lib -r #{gem_name}.rb)
  end
end

task default: :spec
