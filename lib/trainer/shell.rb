require 'tempfile'

class Trainer::Shell
  def run(*commands)
    commands.all? { |command| system environment, command, err: :out }
  end

  def unlink
    key_file.unlink
    ssh_file.unlink
  end

  private

  def environment
    {
      'GIT_SSH'        => ssh_file.path,
      'HEROKU_API_KEY' => ENV['TRAINER_HEROKU_API_KEY']
    }
  end

  def key_file
    @key_file ||= Tempfile.new('private.key').tap do |file|
      file.write ENV['TRAINER_PRIVATE_KEY']
      file.close
    end
  end

  def ssh_file
    @ssh_file ||= Tempfile.new('ssh.config').tap do |file|
      file.write <<-SSH
#!/bin/sh
exec /usr/bin/ssh -o StrictHostKeyChecking=no -o IdentitiesOnly=yes -o UserKnownHostsFile=/dev/null -i #{key_file.path} "$@"
      SSH
      file.close
      system "chmod +x #{file.path}"
    end
  end
end
