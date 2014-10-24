# coding: utf-8

require_relative 'exclusive'
require_relative 'shared'
require_relative 'shared_cache'
require_relative 'method_missing'
require_relative 'proxy_method_missing'

#* core/proxy.rb - A module to allow existing Ruby classes to serve as fOOrth
#  classes as well. This is done via a proxy mechanism.
module XfOOrth

  #Wrap a proxy around an existing Ruby class so that it acts as a fOOrth class.
  #<br>Parameters:
  #* target_class - The Ruby class to be wrapped.
  #* foorth_parent - The fOOrth class that serves as parent.
  #<br>Returns:
  #* The newly created proxy class.
  #<br> Endemic Code Smells
  #* :reek:TooManyStatements
  def self.create_proxy(target_class, foorth_parent)
    name = target_class.name

    target_class.define_singleton_method(:foorth_parent,
      &lambda {foorth_parent})

    target_class.define_singleton_method(:foorth_class,
      &lambda {XfOOrth.class_class})

    target_class.write_var(:@instance_template, target_class)

    target_class.send(:define_method, :foorth_class,
      &lambda {target_class})

    target_class.send(:define_method, :name,
      &lambda {"#{foorth_class.name} instance."})

    target_class.extend(SharedCache)
    target_class.extend(Shared)
    target_class.send(:include, Exclusive)
    target_class.extend(Exclusive)
    target_class.send(:include, MethodMissing)
    target_class.extend(ProxyMethodMissing)

    foorth_parent.foorth_child_classes[name] = target_class
    all_classes[name] = target_class
    @object_class.create_shared_method(name, ClassWordSpec, [])
  end

end
