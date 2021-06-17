# TODO: Tests for main generate_telemetry file
# require './bin/generate_telemetry'

describe 'generate_telemetry' do
  describe '#load_config_file' do
    it 'opens a file and returns a list of lines'
    it 'uses the default configuration if no file is given'
    it 'uses the default configuration if an invalid file name is given'
  end

  describe '#generate_action_list' do
    it 'skips comments and newlines'
    it 'validates that each line contains a supported class name and arguments'
    it 'loads valid parameters into an array'
    it 'raises an error when an invalid parameter is given'
  end

  describe '#initialize_actions' do
    it 'creates a new object for every element in the action list'
    it 'initializes all actions with given parameters'
  end

  describe '#generate_log' do
    it 'generates a json file with logs for all objects'
  end
end
