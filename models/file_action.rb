require 'fileutils'
require './lib/hash_constructed'
# Actions for creating, modifying, and deleting files
class FileAction < Action
  # include HashConstructed
  @@defaults = { disposition: :created, filename: "test_file_#{Time.now.utc.strftime('%m%d%Y_%H%M%S')}", ext: 'txt' }
  attr_accessor :disposition, :filename, :ext
  attr_reader :commandline

  def self.defaults
    @@defaults
  end

  def initialize(hash = {})
    super()
    init_values_from_hash(@@defaults, hash)
    if @filename.include?('.')
      @ext = @filename.split('.')[1..].join
    else
      @filename = "#{@filename}.#{@ext}"
    end
  end

  def execute
    create_file
    case @descriptor
    when :modified
      modify_file(@filename)
    when :deleted
      delete_file(@filename)
    end
  end

  def file_process(command)
    @commandline = "#{command} #{@filename}"
    @process_name = @commandline.split(' ')[0]
    IO.popen(@commandline) do |process|
      @pid = process.pid
    end
  end

  def create_file
    file_process('touch')
    File.open(@filename) do |file_object|
      @filepath = File.absolute_path(file_object)
      @created_at = File.birthtime(file_object)
      @extension = File.extname(file_object)
    end
  end

  def modify_file
    raise "Error: File not found." unless File.exist?(@filepath)

    file_process('touch')
    @modified_at = File.mtime(@filepath)
  end

  def delete_file
    raise "Error: File not found." unless File.exist?(@filepath)

    file_process('rm')
    @deleted_at = Time.now.utc
  end
end
