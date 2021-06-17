# Introduction
`generate_telemetry` is a lightweight Ruby app that generates process, file, and network activity. The resulting telemetry can be used to test that an EDR sensor is capturing data as expected.

# Usage
The app can be run in a command line with `ruby generate_telemetry.rb` If desired, the user can create a configuration file with a list of actions and specify that file as a command line argument. 

```
ruby generate_telemetry.rb my_config_file.txt
``` 

If no configuration file is supplied, `generate_telemetry` will use `example_config.txt` by default.

# Configuration File

Each line of the configuration file must specify an action type and any desired parameters, as in `example_config.txt`
```code
# Process Operations
Process Action, commandline: uname -a
Process Action, commandline: ls

# File Operations
File Action, disposition: created, filename: my_new_file.tar
File Action, disposition: modified, ext: csv
File Action, disposition: deleted, ext: exe, filename: definitely_not_evil

# Network Operations
Network Connection, url: www.google.com
Network Connection, url: www.redcanary.com
```
Supported action types and parameters:
Action Type | Parameters
-- | --
Process Action | commandline
File Action | disposition (created, modified, or deleted), filename, ext
Network Connection | url

# Platforms Tested
- Ruby 2.6.6 on MacOS 19.6.0 Darwin
- Ruby 2.7.0 on Ubuntu 20.04 Focal Fossa

# Assumptions
- UTC timestamps are acceptable.
- Cleanup of all generated test files is not necessary
- Network Connections
  - Protocol value can be Network Protocol, rather than Application Protocol (TCP instead of HTTP)
  - Data transferred may refer to the bytes returned from the remote web server following a network request
  - Data transferred may be counted in bytes

# Future Improvements
- Support Windows OS
- Support HTTPS addresses for network connections
- Add optional delay between each action. Cross-referencing log data with EDR telemetry is challenging when all of the timestamps are similar.
- Refactor `generate_telemetry.rb` with multiple classes instead of handling configuration input, validation, and execution in one file
- Support multiple log output formats and custom log filename