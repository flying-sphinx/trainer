require 'bundler'

Bundler.require :default

$:.unshift File.join(File.expand_path(File.dirname(__FILE__)), 'lib')
require 'trainer'

namespace :train do
  Trainer.repositories.each do |repository|
    task repository do
      Trainer::Whip.crack repository
    end
  end
end

task :train do
  Trainer.train
end
