# Setup debugger

require 'ruby-debug-ide'
require 'ostruct'

$stdout.sync = true

options = OpenStruct.new(
  'frame_bind' => true,
  'host' => nil,
  'load_mode' => false ,
  'port' => 1234,
  'stop' => false,
  'tracing' => true,
  'skip_wait_for_start' => true,
  'int_handler' => true,
  'dispatcher_port' => -1,
  'evaluation_timeout' => 10,
  'trace_to_s' => false,
  'debugger_memory_limit' => 10,
  'inspect_time_limit' => 300,
  'rm_protocol_extensions' => false,
  'catchpoint_deleted_event' => false,
  'value_as_nested_element' => true,
  'attach_mode' => false,
  'cli_debug' => false,
  'key_value_mode' => true,
  'socket_path' => nil,
)
# options.skip_wait_for_start = true

if !options.attach_mode
  Debugger::PROG_SCRIPT = './Ruby-files/Initializers/Main.rb'
else
  Debugger::PROG_SCRIPT = $0
end

list_path = File.join('Ruby-files/', '_scripts.txt')
IO.foreach(list_path) do |name|
  name.strip!
  next if name.empty? || name.start_with?('#') || name == "Initializers/Main"
  puts "Loading #{name}"

  require_relative "Ruby-files/#{name}"
end

if options.dispatcher_port != -1
  ENV['IDE_PROCESS_DISPATCHER'] = options.dispatcher_port.to_s
  require 'ruby-debug-ide/multiprocess'

  Debugger::MultiProcess.do_monkey

  ENV['DEBUGGER_STORED_RUBYLIB'] = ENV['RUBYLIB']
  old_opts = ENV['RUBYOPT'] || ''
  starter = "-r#{File.expand_path(File.dirname(__FILE__))}/../lib/ruby-debug-ide/multiprocess/starter"
  unless old_opts.include? starter
    ENV['RUBYOPT'] = starter
    ENV['RUBYOPT'] += " #{old_opts}" if old_opts != ''
  end
  ENV['DEBUGGER_CLI_DEBUG'] = Debugger.cli_debug.to_s
end

if options.int_handler
  # install interruption handler
  trap('INT') { Debugger.interrupt_last }
end

# set options
Debugger.keep_frame_binding = options.frame_bind
Debugger.tracing = options.tracing
Debugger.evaluation_timeout = options.evaluation_timeout
Debugger.trace_to_s = options.trace_to_s && (options.debugger_memory_limit > 0 || options.inspect_time_limit > 0)
Debugger.debugger_memory_limit = options.debugger_memory_limit
Debugger.inspect_time_limit = options.inspect_time_limit
Debugger.catchpoint_deleted_event = options.catchpoint_deleted_event || options.rm_protocol_extensions
Debugger.value_as_nested_element = options.value_as_nested_element || options.rm_protocol_extensions
Debugger.key_value_mode = options.key_value_mode

# Start debugger
if options.attach_mode
  require 'ruby-debug-ide/multiprocess'
  if Debugger::FRONT_END == 'debase'
    Debugger.init_variables
  end

  Debugger::MultiProcess::pre_child(options)

  if Debugger::FRONT_END == 'debase'
    Debugger.setup_tracepoints
    Debugger.prepare_context
  end
else
  Debugger.debug_program(options)
end
