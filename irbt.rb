# coding: utf-8
# An IRB + fOOrth Test bed

require 'irb'
$force_alias_read_line_module = true
require 'mini_readline'

puts "Starting an IRB console with fOOrth loaded."

if ARGV[0] == 'local'
  require_relative 'lib/fOOrth'
  puts "fOOrth loaded locally: #{XfOOrth::VERSION}"

  ARGV.shift
else
  require 'fOOrth'
  puts "fOOrth loaded from gem: #{XfOOrth::VERSION}"
end

IRB.start
