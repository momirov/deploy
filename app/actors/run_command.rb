require 'pty'

class RunCommand
  include Celluloid
  INACTIVITY_TIMEOUT = 300 # wait 5 minutes for inactivity

  def run(cmd, cwd)
    begin
      Bundler.with_clean_env do
        PTY.spawn( "cd #{cwd} && #{cmd}" ) do |stdout, stdin, pid|
          begin
            stdout.each do |line|
              puts line
            end
          rescue Errno::EIO
          end
          Process.wait(pid)
        end
      end
    rescue PTY::ChildExited => e
    end
  end
end
