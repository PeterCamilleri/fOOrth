# coding: utf-8

#* library/hash_library.rb - Hash support for the fOOrth library.
module XfOOrth

  #Connect the Array class to the fOOrth class system.
  Hash.create_foorth_proxy

  # [] Hash .new [{}]; create an empty hash.
  # The default implementation from Object is used for this.

  # [] { k1 v1 -> ... kn vn -> } [{k1=>v1,...kn=>vn}]; a hash literal value
  VirtualMachine.create_shared_method('{', VmSpec, [:immediate], &lambda { |vm|
    vm.nest_mode('vm.push(Hash.new); ', :hash_literal)

    vm.context.create_local_method('->', LocalSpec, [:immediate],
      &lambda {|vm| vm.process_text('vm.add_to_hash; ') })

    vm.context.create_local_method('}', LocalSpec, [:immediate],
      &lambda {|vm| vm.unnest_mode('', [:hash_literal]) })
  })

  # [hash] .each{{ ... }} [unspecified]
  Hash.create_shared_method('.each{{', NosSpec, [], &lambda { |vm|
    block = vm.pop
    self.each { |idx, val| block.call(vm, val, idx) }
  })

  # [i h] .[]@ [h[i]]
  Hash.create_shared_method('.[]@', TosSpec, [],
    &lambda {|vm| vm.poke(self[vm.peek]); })

  # [v i h] .[]! []; h[i]=v
  Hash.create_shared_method('.[]!', TosSpec, [],
    &lambda {|vm| value, index = vm.popm(2); self[index] = value; })

  # [{"a"=>1, "b"=>2}] .length [2]]
  Hash.create_shared_method('.length', TosSpec, [],
    &lambda {|vm| vm.push(self.length); })

  # [a_hash] .empty? [a_boolean]]
  Hash.create_shared_method('.empty?', TosSpec, [],
    &lambda {|vm| vm.push(self.empty?); })

  # [h] .keys [[keys]]
  Hash.create_shared_method('.keys', TosSpec, [],
    &lambda {|vm| vm.push(self.keys); })

  # [h] .values [[values]]
  Hash.create_shared_method('.values', TosSpec, [],
    &lambda {|vm| vm.push(self.values); })

  # [h] .strmax2 [widest_key widest_value]
  Hash.create_shared_method('.strmax2', TosSpec, [], &lambda {|vm|
    widest_key = 0
    widest_value = 0

    self.each {|key, value|
      key.foorth_strlen(vm)
      temp = vm.pop
      widest_key = widest_key > temp ? widest_key : temp

      value.foorth_strlen(vm)
      temp = vm.pop
      widest_value = widest_value > temp ? widest_value : temp
    }

    vm.push(widest_key)
    vm.push(widest_value)
  })

  # [hash] .to_s [string]
  Hash.create_shared_method('.to_s', TosSpec, [], &lambda {|vm|
    result = "{ "

    self.each do |key, value|
      key.to_foorth_s(vm)
      result << vm.pop + " "

      value.to_foorth_s(vm)
      result << vm.pop + " -> "
    end

    vm.push(result + "}")
  })

  #[a_hash] .to_h [a_hash]
  Hash.create_shared_method('.to_h', TosSpec, [],
    &lambda{|vm| vm.push(self)})

  #[a_hash] .to_a [an_array]
  Hash.create_shared_method('.to_a', TosSpec, [],
    &lambda{|vm| vm.push(self.values)})

  # [a_hash] .map{{ ... }} [mapped_array]
  Hash.create_shared_method('.map{{', NosSpec, [], &lambda { |vm|
    block = vm.pop
    result = []

    self.each do |idx, val|
      block.call(vm, val, idx)
      result << vm.pop
    end

    vm.push(result)
  })

  # [a_hash] .select{{ ... }} [selected_array]
  Hash.create_shared_method('.select{{', NosSpec, [], &lambda { |vm|
    block = vm.pop
    result = []

    self.each do |idx, val|
      block.call(vm, val, idx)
      result << val if vm.pop
    end

    vm.push(result)
  })


  # [h] .pp []; pretty print the hash!
  Hash.create_shared_method('.pp', TosSpec, [], &lambda {|vm|
    self.foorth_strmax2(vm)
    value_width = vm.pop
    key_width   = vm.pop

    width = value_width + key_width + 3
    cols  = (width < 79) ? (79 / width) : 1
    col   = (1..cols).cycle

    self.each do |key, value|
      key.to_foorth_s(vm)
      key_str = vm.pop

      value.to_foorth_s(vm)
      value_str = vm.pop

      if cols > 1
        print "#{key_str.rjust(key_width)}=>#{value_str.ljust(value_width)} "
      else
        print "#{key_str.rjust(key_width)}=>#{value_str}"
      end

      puts if col.next == cols
    end
  })


end

#* Runtime library support for fOOrth constructs.
class Hash

  #A helper method to extract non-stub method names from a method hash.
  def extract_method_names(search_type = :no_stubs)
    search_value = (search_type == :stubs)
    mkeys = self.keys.select {|key| search_value == self[key].has_tag?(:stub)  }
    mkeys.collect {|key| XfOOrth::SymbolMap.unmap(key) || '?error?' }
  end
end
