require './models/network_connection'

describe NetworkConnection do
  before :each do
    @network_connection = NetworkConnection.new({ url: 'www.example.com' })
  end

  it 'has a url' do
    expect(@network_connection.url).to eq('www.example.com')
  end

  it 'updates network data after opening connection' do
    fields = %i[local_ip local_port remote_ip remote_port protocol response_bytesize]
    fields.each { |field| expect(@network_connection.send(field).nil?).to eq(true) }
    @network_connection.execute
    fields.each { |field| expect(@network_connection.send(field).nil?).to eq(false) }
  end
end
