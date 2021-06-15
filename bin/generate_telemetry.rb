require './models/action'
# Base Action
Action.new('uname -a')

# Spawn Process
Action.new('ls')

# Create File
FileAction.new(:created, 'txt')
FileAction.new(:created, 'csv', 'this_is_a_csv')
FileAction.new(:created, 'exe', 'definitely_not_evil')

# Modify File
FileAction.new(:modified)

# Delete File
FileAction.new(:deleted, 'exe', 'test_binary')

# Network Connection
NetworkConnection.new('www.google.com')
NetworkConnection.new('www.redcanary.com')
