require 'json'
require 'active_support'
# Base action for generating telemetry
class Action
  def initialize
    @username = ENV['USER']
  end

  def init_values_from_hash(defaults, hash={})
    # puts "defaults: #{defaults.inspect}"
    # puts "hash: #{hash.inspect}"
    defaults.merge(hash).each { |k, v| public_send("#{k}=", v) }
  end

  def to_json(*_args)
    hash = { type: self.class }
    instance_variables.each do |var|
      hash[var[1..]] = instance_variable_get var
    end
    hash
  end

  def log
    puts JSON.pretty_generate(to_json)
  end
end
