# coding: utf-8

#require_relative 'exclusive'
require_relative 'shared_cache'
require_relative 'method_missing'
require_relative 'shared'

#* core/proxy.rb - A module to allow existing Ruby classes to serve as fOOrth
#  classes as well. This is done via a proxy mechanism.
module XfOOrth

  #Wrap a proxy around an existing Ruby class so that it acts as a fOOrth class.
  #<br>Parameters:
  #* target_class - The Ruby class to be wrapped.
  #* foorth_parent - The fOOrth class that serves as parent.
  #<br>Returns:
  #* The newly created proxy class.
  def self.create_proxy(target_class, foorth_parent)
    target_class.define_singleton_method(:foorth_parent) {foorth_parent}
    target_class.define_singleton_method(:foorth_class)  {XfOOrth.class_class}
    target_class.define_singleton_method(:shared)        {@shared ||= {}}

    target_class.send(:define_method, :foorth_class,
      &lambda {target_class})

    target_class.send(:define_method, :name,
      &lambda {"#{foorth_class.name} instance."})

    target_class.extend(SharedCache)
    target_class.extend(Shared)
    target_class.send(:include, MethodMissing)

    target_class
  end


end
