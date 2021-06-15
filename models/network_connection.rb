require 'socket'

# Class for creating a network connection and sending data
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
    puts JSON.pretty_generate(to_json)
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
