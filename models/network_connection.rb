require 'socket'

# Class for creating a network connection and sending data
class NetworkConnection < Action
  @@defaults = { url: 'www.google.com' }
  attr_accessor :url

  def self.defaults
    @@defaults
  end

  def initialize(hash = {})
    super()
    init_values_from_hash(@@defaults, hash)
  end

  def execute
    connect_to(@url)
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
