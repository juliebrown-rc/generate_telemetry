# Class for spawning a new process, given a command line string
class ProcessAction < Action
  @@defaults = { commandline: 'ls' }
  attr_accessor :commandline, :process_name, :args

  def self.defaults
    @@defaults
  end

  def initialize(hash = {})
    super()
    init_values_from_hash(@@defaults, hash)
    @process_name = commandline.split(' ')[0]
    @args = commandline.split(' ')[1..]
    @path = IO.popen(['which', @process_name]).read.chomp
  end

  def execute
    @timestamp = Time.now.utc
    f = IO.popen(@commandline)
    @pid = f.pid
    f.close
  end
end
