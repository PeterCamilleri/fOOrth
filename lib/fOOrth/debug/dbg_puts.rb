# coding: utf-8

#* debug/dbg_puts.rb - Display diagnostic/debug information if enabled.
module XfOOrth

  #* debug/dbg_puts.rb - Display diagnostic/debug information if enabled.
  class VirtualMachine

    #Send out debug info to the fOOrth debug port if debug is enabled.
    def dbg_puts(*args)
      $foorth_dbg.puts(*args) if debug
    end

  end

end

