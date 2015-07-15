# coding: utf-8

#* compiler/modes/delayed.rb - The delayed compile system mode.
module XfOOrth
  #* compiler/modes/delayed.rb - The delayed compile system mode.
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
    #<br>Endemic Code Smells
    # :reek:FeatureEnvy
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
