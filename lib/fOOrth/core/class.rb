# coding: utf-8

require_relative 'shared'

#* core/class.rb - The generic class class of the fOOrth language system.
module XfOOrth

  #The \XClass class is basis for all fOOrth classes.
  class XClass < XObject
    include Shared

    #The base Ruby class for instances of this class.
    def instance_base_class
      XObject
    end

    #The name of the fOOrth class.
    attr_reader :name

    #The parent fOOrth class of this one.
    #<br>Special Cases:
    #* The \foorth_parent of the fOOrth class "Object" is nil.
    attr_reader :foorth_parent

    #Create an new instance of a fOOrth class.
    #<br>Parameters:
    #* name - The name of this fOOrth class.
    #* \foorth_parent - The class that is the parent of this class.
    def initialize(name, foorth_parent)
      @name          = name
      @foorth_parent = foorth_parent
      foorth_class   = self

      all = XfOOrth.all_classes

      if all.has_key?(@name)
        error "Class #{@name} already exists."
      else
        all[@name]  = self
      end

      #Setup the Ruby shadow class used to create instances of this fOOrth class.
      @instance_template = Class.new(self.instance_base_class) do
        @foorth_class = foorth_class
      end
    end

    #Set the class's parent class for the case where this can not be done
    #when the class is constructed.
    def set_foorth_parent(foorth_parent)
      @foorth_parent = foorth_parent
    end

    #Create a new fOOrth subclass of this class.
    #<br>Parameters:
    #* name - The name of the new sub-class.
    #<br>Note:
    #* If a sub-class with the given name already exists, that class is returned.
    def create_foorth_subclass(name)
      anon = Class.new(XClass) {@foorth_class = XfOOrth.class_class}
      new_class = anon.new(name, self)
      foorth_child_classes[name] = new_class
      new_class
    end

    #Create an instance of this fOOrth class.
    #<br>Parameters:
    #* vm - The current fOOrth virtual machine.
    def create_foorth_instance(vm)
      obj = @instance_template.new
      obj.foorth_init(vm)
      obj
    end

  end
end
