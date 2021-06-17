require './models/action'

describe Action do
  before :each do
    @action = Action.new
  end

  it 'has a timestamp, username, and PID' do
    @action.instance_variables.each do |var|
      expect(['@timestamp', '@username', '@pid']).to include(var.to_s)
    end
  end

  it 'has a timestamp matching when the action was created' do
    expect(@action.timestamp.to_i).to eq(Time.now.utc.to_i)
  end

  it 'can be initialized by a hash' do
    sample_time = Time.now
    sample_defaults = {'timestamp': sample_time, 'username': 'Test User', 'pid': '12345'}
    @action.init_values_from_hash(sample_defaults)

    expect(@action.timestamp).to eq(sample_time)
    expect(@action.username).to eq('Test User')
    expect(@action.pid).to eq('12345')
  end

  it 'generates a JSON object' do
    log_hash = {
      :type => Action,
      "timestamp" => @action.timestamp,
      "username" => @action.username,
      "pid" => @action.pid
    }

    expect(@action.to_json).to eq(log_hash)
  end
end
