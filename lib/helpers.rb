module Helpers
  def self.run_cmd(cmd)
    time = Benchmark.measure do
      ret_code = Open4.popen4(cmd) do |pid, inn, out, err|
        output = ""
        until out.eof?
          # raise "Timeout" if output.empty? && Time.now.to_i - start > 300
          chr = out.read(1)
          output << chr
          if chr == "\n" || chr == "\r"
            log_and_stream output + "<br>"
            output = ""
          end
        end
        log_and_stream(output) unless output.empty?
        log_and_stream("<span class='stderr'>STDERR: #{err.read}</span><br>") unless err.eof?
      end
      raise 'process_failed' unless ret_code == 0
    end
  end

  def self.log_and_stream(output)
    write_file output, @filename if @filename
    @output += output
  end
end
