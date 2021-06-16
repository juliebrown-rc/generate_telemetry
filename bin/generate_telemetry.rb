require './models/action'
require './models/file_action'
require './models/network_connection'
require './models/process_action'
require 'pry'

# method from stackoverflow
def class_exists?(class_name)
  klass = Module.const_get(class_name)
  return klass.is_a?(Class)
  rescue NameError
  return false
end

# Test that config file exists
config_filename = ARGV[0]
if File.exist?(config_filename.to_s)
  print "Reading config file..."
else
  puts "Configuration not found. To supply a list of actions, use 'ruby bin/generate_telemetry.rb my-config.txt'"
  config_filename = 'example_config.txt'
  print "Using sample config file..."
end

input = File.open(config_filename).each_line
puts "done."

print "Validating input..."
action_list = []
input.each_with_index do |line, l|
  next if line.start_with?('#', "\n")
  class_name = line.split(',').first.split(' ').map(&:capitalize).join
  raise "Error in config file at line #{l + 1}: Action type not supported." unless class_exists?(class_name)

  # check that all method params are valid and load into hash before executing
  action = { 'class' => class_name }
  line.split(',')[1..].each do |param|
    key = param.split(':').first.strip
    value = param.split(':')[1].strip
    unless Object.const_get(class_name).defaults.keys.include? key.to_sym
      raise "Error: invalid parameter #{key} given at line #{l + 1}."
    end

    action[key] = value
  end
  action_list << action
end
puts "done."

print "Initializing Actions..."
objects = []
action_list.each do |hash|
  args_hash = hash.except('class') 
  # puts "running command #{hash['class']}.new(#{args_hash})"
  objects << Object.const_get(hash['class']).new(args_hash)
end
puts "done."

print "Running actions..."
objects.each(&:execute)
puts "done."

print "Generating log..."
output_hash = {}
objects.each_with_index do |object, index|
  output_hash["#{index + 1}. #{object.class}"] = object.to_json
end

output_filename = "log_#{Time.now.utc.strftime('%m%d%Y_%H%M%S')}.json"
File.write(output_filename, JSON.pretty_generate(output_hash))
puts "done. (#{output_filename})"
