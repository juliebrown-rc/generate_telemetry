# Class for spawning a new process, given a command line string
class ProcessAction < Action
  @@defaults = { commandline: 'ls' }
  attr_accessor :commandline

  def self.defaults
    @@defaults
  end

  def initialize(hash = {})
    super()
    # binding.pry
    # puts "initialize ProcessAction with defaults: #{self.class.defaults.inspect}"
    init_values_from_hash(@@defaults, hash)
    @process_name = commandline.split(' ')[0]
    @args = commandline.split(' ')[1..]
    @path = IO.popen(['which', @process_name]).read.chomp
  end

  def execute
    f = IO.popen(@commandline)
    # @output = f.readlines
    @pid = f.pid
    f.close
  end
end
