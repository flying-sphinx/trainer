require 'tmpdir'
require 'fileutils'

class Trainer::Whip
  APP_NAME = ENV['TRAINER_HEROKU_APP_NAME']

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
      "git remote add heroku git@heroku.com:#{APP_NAME}.git",
      "git push heroku master --force"
    )

    shell.run(
      "heroku run rake db:migrate -a #{APP_NAME}",
      "heroku run rake trainer:prepare -a #{APP_NAME}",
      "heroku run bundle exec flying-sphinx configure -a #{APP_NAME}",
      "heroku run bundle exec flying-sphinx index -a #{APP_NAME}",
      "heroku run bundle exec flying-sphinx start -a #{APP_NAME}"
    )

    test
    shell.run "heroku run bundle exec flying-sphinx rebuild -a #{APP_NAME}"
    test

    shell.run "heroku run bundle exec flying-sphinx stop -a #{APP_NAME}"
  ensure
    Dir.chdir '/'

    FileUtils.remove_entry directory
    shell.unlink
  end

  def test
    notify unless shell.run 'heroku run rake trainer:test -a #{APP_NAME}'
  end

  private

  attr_reader :repository

  def directory
    @directory ||= Dir.mktmpdir
  end

  def notify
    raise "Test Failed"
  end

  def path
    @path ||= File.join directory, repository
  end

  def shell
    @shell ||= Trainer::Shell.new
  end
end
