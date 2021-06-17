require './models/action'
require './models/file_action'
require './models/network_connection'
require './models/process_action'
require 'active_support'
require 'pry'

def class_exists?(class_name)
  variable_as_class = Module.const_get(class_name)
  return variable_as_class.is_a?(Class)
  rescue NameError
  return false
end

def load_config_file(config_filename)
  if File.exist?(config_filename.to_s)
    print "Reading config file..."
  else
    puts "Configuration not found. To supply a list of actions, use 'ruby bin/generate_telemetry.rb my-config.txt'"
    config_filename = 'example_config.txt'
    print "Using sample config file..."
  end
  input = File.open(config_filename).each_line
  puts "done."
  input
end

def generate_action_list(input_array)
  print "Validating input..."
  action_list = []
  input_array.each_with_index do |line, l|
    next if line.start_with?('#', "\n")
    class_name = line.split(',').first.split(' ').map(&:capitalize).join
    raise "Error in config file at line #{l + 1}: Action type not supported." unless class_exists?(class_name)

    # Check that all method params are valid and load into hash before executing
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
  action_list
end

def initialize_actions(action_list)
  print "Initializing Actions..."
  objects = []
  action_list.each do |hash|
    args_hash = hash.except('class') 
    objects << Object.const_get(hash['class']).new(args_hash)
  end
  puts "done."
  objects
end

def generate_log(objects)
  print "Generating log..."
  output_hash = {}
  objects.each_with_index do |object, index|
    output_hash["#{index + 1}. #{object.class}"] = object.to_json
  end
  output_filename = "log_#{Time.now.utc.strftime('%m%d%Y_%H%M%S')}.json"
  File.write(output_filename, JSON.pretty_generate(output_hash))
  puts "done. (#{output_filename})"
end

input = load_config_file(ARGV[0])
action_list = generate_action_list(input)
objects = initialize_actions(action_list)

print "Running actions..."
objects.each(&:execute)
puts "done."

generate_log(objects)
