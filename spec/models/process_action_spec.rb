require './models/process_action'

describe ProcessAction do
  before :each do
    @process_action = ProcessAction.new({ commandline: "echo 'my test process'" })
  end

  it 'has a commandline' do
    expect(@process_action.commandline).to eq("echo 'my test process'")
  end

  it 'sets the process name and args correctly' do
    expect(@process_action.process_name).to eq("echo")
    expect(@process_action.args.join(' ')).to eq("'my test process'")
  end

  it 'updates object pid to match the spawned process' do 
    parent_pid = @process_action.pid
    @process_action.execute
    expect(@process_action.pid).not_to eq(parent_pid)
  end
end
