require 'socket'

def print_system_info
    puts "SYSTEM INFO"
    puts "RUBY_PLATFORM = #{RUBY_PLATFORM}"
end

def print_common_attributes(section='')
    sleep(rand(5..10))
    # TODO: Process name
    # TODO: Process command line
    puts "\n" + section.upcase
    puts "Timestamp = #{Time.now.utc}"
    puts "Process ID = #{Process.pid}"
    puts "uid = #{Process.uid}"
    puts "Username = #{ENV['USER']}"
end

def test_process_start
    fork_child_pid = Process.fork do
        print_common_attributes('process start')
        # puts "$0 = #{$0}\nargv0 = #{Process.argv0}\nARGV = #{ARGV}\nSys.getuid = #{Process::Sys.getuid}"
    end
    Process.wait
end

def print_file_attributes(filename, action)
    puts "Descriptor = #{action.downcase}"
    puts "File Path = #{File.absolute_path(filename)}"
    puts "Created at = #{File.birthtime(filename)}"
    puts "Modified at = #{File.mtime(filename)}"
    puts "File Extension = #{File.extname(filename)}"
end

def file_setup(ext)
    filename = "test_file_#{Time.now.utc.strftime("%m%d%Y_%H%M%S")}.#{ext}"
    file = File.open(filename, 'w')
    file.write("This is some sample text")
    file.close
    filename
end

def test_file_creation
    print_common_attributes('file creation')
    created_filename = file_setup('txt')
    print_file_attributes(created_filename, :created)
    File.delete(created_filename)
end

def test_file_modification
    print_common_attributes('file modification')
    modified_filename = file_setup('txt')
    puts "sleeping..."
    sleep(rand(5..10))
    modified_file = File.open(modified_filename, 'w')
    modified_file.write("This is additional text added later.")
    modified_file.close
    print_file_attributes(modified_filename, :modified)
    File.delete(modified_filename)
end

def test_file_deletion
    print_common_attributes('file deletion')
    deleted_filename = file_setup('txt')
    print_file_attributes(deleted_filename, :deleted)
    File.delete(deleted_filename)
end

def print_ip_info(socket)
    puts "Local IP = #{socket.local_address.ip_address}"
    puts "Local Port = #{socket.local_address.ip_port}"
    puts "Remote IP = #{socket.remote_address.ip_address}"
    puts "Remote Port = #{socket.remote_address.ip_port}"
    puts "Protocol = #{socket.local_address.protocol}"
end

# print_system_info

# Process Start
# test_process_start

# File Operations
# test_file_creation
# test_file_modification
# test_file_deletion

# Network Connection
print_common_attributes('network connection and data transmission')

# ○ Amount of data sent
# ○ Protocol of data sent

s = TCPSocket.open 'www.google.com', 80
s.puts "GET / HTTP/1.1\n\n"
s.puts "\n\n"
# # while line = s.gets
# #     puts line.chop
# # end

print_ip_info(s)

response_bytesize = 0
while line = s.gets
    puts line
    response_bytesize += line.bytesize
end
s.close

puts "response_bytesize = #{response_bytesize}"

# Clarifying Questions
# Cleanup requirements?
# Is UTC acceptable for timestamps?
# What configuration parameters should exist?
# Protocol - Application Protocol or Network Protocol? (HTTP vs TCP)
# For data transfer size, is bytes acceptable, or should it be in another unit?
# Is there any restrictions on libraries/gems that can be used?
# Should the files all be placed in the working directory? Do we need to input file path from the config?






# puts "-------------------------\nFILE"
# commandline = "uname -a"
# f = IO.popen(commandline)
# output = f.readlines
# puts "Process.pid = #{Process.pid}"
# puts "output = #{output}"
# puts "f.pid = #{f.pid}"
# puts "commandline = #{commandline}"
# f.close
# puts "$? = #{$?}"


# puts "---"

# puts "Process.pid = #{Process.pid}"




# puts "\nBLOCK"
# IO.popen("date") {|f| puts f.gets }
# puts "Process.pid = #{Process.pid}"
# puts "$? = #{$?.inspect}"

# puts "\nBLOCK 2"
# IO.popen("-") {|f| $stderr.puts "#{Process.pid} is here, f is #{f.inspect}"}

# puts "\n$?"
# p $?

# puts "\nARGS WITH r+"
# IO.popen(%w"sed -e s|^|<foo>| -e s&$&;zot;&", "r+") {|f|
#   f.puts "bar"; f.close_write; puts f.gets
# }