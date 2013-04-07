require 'gh'

module Trainer
  ORGANISATION = ENV['TRAINER_ORGANISATION']

  def self.repositories
    GH["orgs/#{ORGANISATION}/repos"].collect { |hash|
      hash['name']
    } - ['trainer']
  end

  def self.train
    repositories.each do |repository|
      Trainer::Whip.crack repository
    end
  end
end

require 'trainer/shell'
require 'trainer/whip'
