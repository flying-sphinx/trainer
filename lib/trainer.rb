require 'gh'
require 'mail'

Mail.defaults do
  delivery_method :smtp,
    :address              => "smtp.sendgrid.net",
    :port                 => 25,
    :domain               => ENV['SENDGRID_DOMAIN'],
    :user_name            => ENV['SENDGRID_USERNAME'],
    :password             => ENV['SENDGRID_PASSWORD'],
    :authentication       => 'plain'
end

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
