require 'socket'

# Class for creating a network connection and sending data
class NetworkConnection < Action
  @@defaults = { url: 'www.google.com' }
  attr_accessor :url
  attr_reader :local_ip, :local_port, :remote_ip, :remote_port, :protocol, :response_bytesize

  def self.defaults
    @@defaults
  end

  def initialize(hash = {})
    super()
    init_values_from_hash(@@defaults, hash)
  end

  def execute
    @timestamp = Time.now.utc
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
    @protocol = 'TCP'

    s.close_write
    response = s.read
    @response_bytesize = response.bytesize
    s.close
  end
end
