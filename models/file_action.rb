require 'fileutils'
require './models/process_action'
require './lib/hash_constructed'
# Actions for creating, modifying, and deleting files
class FileAction < Action
  # include HashConstructed
  @@defaults = { disposition: :created, filename: "test_file_#{Time.now.utc.strftime('%m%d%Y_%H%M%S')}", ext: 'txt' }
  attr_accessor :disposition, :filename, :ext

  def self.defaults
    @@defaults
  end

  def initialize(hash)
    super()
    init_values_from_hash(@@defaults, hash)
    if @filename.include?('.')
      @ext = @filename.split('.')[1..].join
    else
      @filename = @filename + '.' + @ext
    end
  end

  def execute
    create_file(@filename)
    case @descriptor
    when :modified
      modify_file(@filename)
    when :deleted
      delete_file(@filename)
    end
  end

  def create_file(filename)
    FileUtils.touch(@filename)
    file_object = File.open(@filename)
    @filepath = File.absolute_path(file_object)
    @created_at = File.birthtime(file_object)
    @extension = File.extname(file_object)
    file_object.close
  end

  def modify_file(filepath)
    sleep(rand(5..10))
    FileUtils.touch(filepath)
    @modified_at = File.mtime(filepath)
  end

  def delete_file(filepath)
    sleep(rand(5..10))
    if File.exist?(filepath)
      File.delete(filepath)
      @deleted_at = Time.now.utc
    else
      # Raise Error: File not found
    end
  end
end

# def create_process(commandline)
#   f = IO.popen(commandline)
#   # @output = f.readlines
#   @pid = f.pid
#   f.close
# end