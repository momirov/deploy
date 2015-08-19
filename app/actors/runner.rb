require 'open3'
require 'pp'

class Runner
  include Celluloid
  include Celluloid::Internals::Logger
  INACTIVITY_TIMEOUT = 600 # wait 10 minutes for inactivity

  def initialize(deployment)
    @deployment = deployment
    @timer = after(INACTIVITY_TIMEOUT) {terminate}
    puts "Starting up..."
  end

  def deploy(cmd)
    exit_code = 0
    start = Time.now.to_i
    timestamp = Time.now.to_s
    ret = ""

    deploy_command = cmd.gsub("{user_name}", @deployment.user)
    Bundler.with_clean_env do
      Open3.popen3("cd #{@deployment.project.get_dir_path} && #{deploy_command}") do |inn, out, err, wait_thr|
        output = ""
        until out.eof?
          # raise "Timeout" if output.empty? && Time.now.to_i - start > 300
          chr = out.read(1).force_encoding('UTF-8')
          output << chr
          ret << chr
          if chr == "\n" || chr == "\r"
            begin
              Pusher["deployment_#{@deployment.id}"].trigger('update_log', {
                new_line: output,
                status: @deployment.status
              })
            rescue => e
              puts 'exception'
              pp e
            end
            output = ""
          end
        end
        error_message = nil
        Pusher["deployment_#{@deployment.id}"].trigger('update_log', {
             new_line: output,
             status: @deployment.status
         })  unless output.empty?

        error_message = err.read unless err.eof?
        unless error_message.nil? then
          puts error_message
          error(error_message)
        end

        # Log non-zero exits
        if wait_thr.value.exitstatus != 0 then
          #log_and_stream("<span class='stderr'>DANGER! #{cmd} had an exit value of: #{wait_thr.value.exitstatus}</span><br>")
          exit_code = wait_thr.value.exitstatus
        end
      end
    end
    if exit_code > 0
      @deployment.status = :error
    else
      @deployment.status = :completed
    end
    @deployment.completed_at = Time.now
    @deployment.log = ret
    begin
      @deployment.save
    rescue => e
      pp e
    end

    deployment.completed_at = Time.now
    deployment.save
    Rails.cache.delete("log_#{deployment_id}")
    Pusher["deployment"].trigger('finished', {
        id: @deployment.id,
        status: @deployment.status,
        time: @depl
    })

    # delete version cache
    Rails.cache.delete("stage_revision_#{@deployment.stage.id}")
    terminate
  end
end
