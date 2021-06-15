require 'json'
class Action
    def initialize(cmdline='')
        @start_time = Time.now.utc
        @username = ENV['USER']
    end

    def to_json
        hash = {type: self.class}
        self.instance_variables.each do |var|
          hash[var[1..]] = self.instance_variable_get var
        end
        hash
    end
end

class ProcessAction < Action
    def initialize(cmdline)
        super
        @process_name = cmdline.split(' ')[0]
        @args = cmdline.split(' ')[1..]
        @path = IO.popen(['which', @process_name]).read.chomp
        @cmdline = cmdline
        create_process(@cmdline)
        puts JSON.pretty_generate(self.to_json)
    end

    def create_process(cmdline)
        f = IO.popen(cmdline)
        # @output = f.readlines
        @pid = f.pid
        f.close
    end
end

require 'fileutils'
class FileAction < ProcessAction
    def initialize(descriptor, ext='txt', filename="test_file_#{Time.now.utc.strftime("%m%d%Y_%H%M%S")}")
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
        puts JSON.pretty_generate(self.to_json)
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

require 'socket'
class NetworkConnection < Action
    # puts "Local IP = #{socket.local_address.ip_address}"
    # puts "Local Port = #{socket.local_address.ip_port}"
    # puts "Remote IP = #{socket.remote_address.ip_address}"
    # puts "Remote Port = #{socket.remote_address.ip_port}"
    # puts "Protocol = #{socket.local_address.protocol}"
    # s = TCPSocket.open 'www.google.com', 80
    # s.puts "GET / HTTP/1.1\n\n"
    # s.puts "\n\n"
    # # while line = s.gets
    # #     puts line.chop
    # # end

    def initialize(url)
        super
        connect_to(url)
        puts JSON.pretty_generate(self.to_json)
    end

    def connect_to(url)
        s = TCPSocket.open(url, 80)
        s.write "GET / HTTP/1.1\r\n\r\n"
        @url = url
        @local_ip = s.local_address.ip_address
        @local_port = s.local_address.ip_port
        @remote_ip = s.remote_address.ip_address
        @remote_port = s.remote_address.ip_port
        @protocol = s.local_address.protocol
    
        s.close_write
        response = s.read
        @response_bytesize = response.bytesize
        s.close
    end
end