# Class for spawning a new process, given a command line and optional arguments
class ProcessAction < Action
  def initialize(cmdline)
    super
    @process_name = cmdline.split(' ')[0]
    @args = cmdline.split(' ')[1..]
    @path = IO.popen(['which', @process_name]).read.chomp
    @cmdline = cmdline
    create_process(@cmdline)
    puts JSON.pretty_generate(to_json)
  end

  def create_process(cmdline)
    f = IO.popen(cmdline)
    # @output = f.readlines
    @pid = f.pid
    f.close
  end
end
