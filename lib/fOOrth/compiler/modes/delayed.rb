# coding: utf-8

#* compiler/modes/compiled.rb - The delayed compile system mode.
module XfOOrth
  #* modes.rb - The control of the various compiler modes.
  class VirtualMachine

    #Enter a delayed compile mode in which compilation is delayed till a
    #later time.
    def delayed_compile_mode(start)
      dbg_puts "  begin_delayed_compile_mode"

      buffer = do_delayed_compile_mode(start)

      dbg_puts "  Append=#{buffer}"
      @buffer << buffer
      dbg_puts "  end_delayed_compile_mode"
    end

    #The worker bee for delayed_compile_mode.
    def do_delayed_compile_mode(start)
      buffer, depth = start + ' ', 1

      while depth > 0
        if (word = parser.get_word_or_string)
          buffer << word + ' '
          depth += 1 if [':', '!:', '.:', '.::'].include?(word)
          depth -= 1 if word == ';'
        else
          error "F12: Error, Invalid compile nesting."
        end
      end

      "vm.process_string(#{buffer.foorth_embed}); "
    end

  end
end
