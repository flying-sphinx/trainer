require 'tmpdir'
require 'fileutils'

class Trainer::Whip
  def self.crack(repository)
    new(repository).crack
  end

  def initialize(repository)
    @repository = repository
  end

  def crack
    shell.run "git clone git://github.com/#{Trainer::ORGANISATION}/#{repository}.git #{path}"
    Dir.chdir path
    shell.run(
      "git remote add heroku git@heroku.com:#{ENV['TRAINER_HEROKU_APP_NAME']}.git",
      "git push heroku master --force"
    )

    shell.run(
      "heroku run rake db:migrate",
      "heroku run rake trainer:prepare",
      "heroku run bundle exec flying-sphinx configure",
      "heroku run bundle exec flying-sphinx index",
      "heroku run bundle exec flying-sphinx start"
    )

    test
    shell.run "heroku run bundle exec flying-sphinx rebuild"
    test

    shell.run "heroku run bundle exec flying-sphinx stop"
  ensure
    Dir.chdir '/'

    FileUtils.remove_entry directory
    shell.unlink
  end

  def test
    notify unless shell.run
  end

  private

  attr_reader :repository

  def directory
    @directory ||= Dir.mktmpdir
  end

  def notify
    #
  end

  def path
    @path ||= File.join directory, repository
  end

  def shell
    @shell ||= Trainer::Shell.new
  end
end
