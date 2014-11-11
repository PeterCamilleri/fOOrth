# coding: utf-8

require_relative 'exclusive'
require_relative 'shared'
require_relative 'shared_cache'
require_relative 'method_missing'
require_relative 'proxy_method_missing'

#* core/proxy.rb - A module to allow existing Ruby classes to serve as fOOrth
#  classes as well. This is done via a proxy mechanism.
module XfOOrth

  #The \XProxy class is basis for all fOOrth classes that wrap Ruby classes. WIP
  class XProxy < XClass

    #The base Ruby class for instances of this class.
    attr_reader :instance_base_class

    #The base Ruby class for this class and its sub_classes.
    def class_base_class
      XProxy
    end

    #Create an new instance of a fOOrth class.
    #<br>Parameters:
    #* ruby_class - The class to be the target of the proxy.
    #* foorth_parent - The class that is the parent of this class.
    def initialize(ruby_class, foorth_parent)
      #Setup the Ruby class used to create instances of this fOOrth class.
      @instance_template = ruby_class

      #Let the super class do most of the work.
      super(ruby_class.name, foorth_parent)

      #Setup the back links
      this_foorth_class = self

      target_class.send(:define_method, :foorth_class,
        &lambda {this_foorth_class})

      target_class.send(:define_method, :foorth_name,
        &lambda {"#{foorth_class.name} instance"})
    end


  end


  # Legacy code to be re-factored, real soon now, follows.

  #Wrap a proxy around an existing Ruby class so that it acts as a fOOrth class.
  #<br>Parameters:
  #* target_class - The Ruby class to be wrapped.
  #* foorth_parent - The fOOrth class that serves as parent.
  #<br>Returns:
  #* The newly created proxy class.
  #<br> Endemic Code Smells
  #* :reek:TooManyStatements
  def self.create_proxy(target_class, foorth_parent)
    name = target_class.name  #Done

    target_class.define_singleton_method(:foorth_parent,
      &lambda {foorth_parent})  #Done from XClass

    target_class.define_singleton_method(:foorth_class,
      &lambda {XfOOrth.class_class})  #Done from XClass

    target_class.define_singleton_method(:foorth_name,
      &lambda {self.name}) #Done from XClass

    target_class.write_var(:@instance_template, target_class) #Done by initialize

    target_class.send(:define_method, :foorth_class,
      &lambda {target_class}) #Needed, Done

    target_class.send(:define_method, :foorth_name,
      &lambda {"#{foorth_class.name} instance"})  #Needed, Done

    target_class.extend(SharedCache)                # In XClass
    target_class.extend(Shared)                     # In XClass
    target_class.send(:include, Exclusive)          # ???????
    target_class.extend(Exclusive)                  # In XClass
    target_class.send(:include, MethodMissing)      #needed or add to ruby Object?
    target_class.extend(ProxyMethodMissing)         # In XClass

    foorth_parent.foorth_child_classes[name] = target_class


    all_classes[name] = target_class   #Done

    #Curious.. This step seems to be missing for non-proxy classes. Now added.
    @object_class.create_shared_method(name, ClassWordSpec, [])
  end

end
