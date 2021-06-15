require 'json'

# Base action for generating telemetry
class Action
  def initialize
    @start_time = Time.now.utc
    @username = ENV['USER']
  end

  def to_json(*_args)
    hash = { type: self.class }
    instance_variables.each do |var|
      hash[var[1..]] = instance_variable_get var
    end
    hash
  end
end
