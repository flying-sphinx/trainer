require 'bundler'

Bundler.require :default

$:.unshift File.join(File.expand_path(File.dirname(__FILE__)), 'lib')
require 'trainer'

task :train do
  Trainer.train
end
