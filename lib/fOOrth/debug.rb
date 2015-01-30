# coding: utf-8

require_relative 'debug/display_abort'
require_relative 'debug/dbg_puts'
require_relative 'debug/context_dump'
require_relative 'debug/vm_dump'

#Set up the default debug conduit.
$foorth_dbg = $stdout

#* debug.rb - Internal debug support.
module XfOOrth
end
