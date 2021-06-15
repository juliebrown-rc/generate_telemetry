require 'fileutils'

# Actions for creating, modifying, and deleting files
class FileAction < ProcessAction
  def initialize(descriptor, ext = 'txt', filename = "test_file_#{Time.now.utc.strftime('%m%d%Y_%H%M%S')}")
    @descriptor = descriptor
    @filename = "#{filename}.#{ext}"
    cmdline = "touch #{@filename}"
    super(cmdline)
    file_object = File.open(@filename)
    @filepath = File.absolute_path(file_object)
    @created_at = File.birthtime(file_object)
    @extension = File.extname(file_object)
    file_object.close
    case @descriptor
    when :modified
      modify_file(@filepath)
    when :deleted
      delete_file(@filepath)
    end
    puts JSON.pretty_generate(to_json)
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
