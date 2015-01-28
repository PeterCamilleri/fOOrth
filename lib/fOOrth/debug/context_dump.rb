# coding: utf-8

#* debug/context_dump.rb - Debug support for the compiler context.
module XfOOrth

  #Debug support for the compiler context.
  class Context

    #Dump the context chain to the console for debug.
    #<br>Parameters
    #* vm - The current virtual machine for this thread.
    def debug_dump(vm)
      puts
      puts "Context level #{self.depth}"

      @data.each do |key, value|
        if key == :vm
          puts "virtual machine => #{value.foorth_name}"
        else
          if (name = SymbolMap.unmap(key))
            key = name.inspect
          end

          puts "#{key} => #{value}"
        end
      end

      (prev = self.previous) && prev.debug_dump(vm)
    end
  end

end