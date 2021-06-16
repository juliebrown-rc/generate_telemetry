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
raise 'Error: File not found. Enter the filename for a valid config file.' unless File.exist?(config_filename.to_s)

puts "Reading config file..."
input = File.open(config_filename).each_line

puts "Validating input..."
action_list = []
input.each_with_index do |line, l|
  puts "Reading line #{l + 1}: #{line}"
  # ignore comments and empty lines
  next if line.start_with?('#', "\n")

  # get elements of each line
  class_name = line.split(',').first.split(' ').map(&:capitalize).join
  raise "Error in config file at line #{l+1}: Action type not supported." unless class_exists?(class_name)

  # check that all method params are valid and load into hash before executing
  action = { 'class' => class_name }
  line.split(',')[1..].each do |param|
    key = param.split(':').first.strip
    value = param.split(':')[1].strip
    puts "Checking key #{key} against #{class_name} supported attributes: #{Object.const_get(class_name).defaults.keys}"
    # binding.pry
    unless Object.const_get(class_name).defaults.keys.include? key.to_sym
      raise "Error: invalid parameter #{key} given at line #{l + 1}."
    end

    #{line}\nValid Params for #{class_name}: #{Object.const_get(class_name).defaults.keys}"
    action[key] = value
  end
  action_list << action
end

puts "Initializing Actions..."
# puts "#{action_list.count} actions initialized:\n#{action_list.join("\n")}"

objects = []
action_list.each do |hash|
  args_hash = hash.except('class') 
  # puts "running command #{hash['class']}.new(#{args_hash})"
  objects << Object.const_get(hash['class']).new(args_hash)
end

puts "Initialized #{objects.count} actions."

puts "Running actions..."
objects.each do |object|
  puts "#{object.class}..."
  object.execute
end
