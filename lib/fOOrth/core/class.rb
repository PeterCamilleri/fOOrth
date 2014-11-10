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

    #The base Ruby class for this class and its sub_classes.
    def class_base_class
      XClass
    end

    #The foorth_name of the fOOrth class.
    attr_reader :foorth_name

    #The parent fOOrth class of this one.
    #<br>Special Cases:
    #* The \foorth_parent of the fOOrth class "Object" is nil.
    attr_reader :foorth_parent

    #Create an new instance of a fOOrth class.
    #<br>Parameters:
    #* foorth_name - The foorth_name of this fOOrth class.
    #* \foorth_parent - The class that is the parent of this class.
    def initialize(foorth_name, foorth_parent)
      @foorth_name   = foorth_name
      @foorth_parent = foorth_parent
      foorth_class   = self

      all = XfOOrth.all_classes

      if all.has_key?(@foorth_name)
        error "Class #{@foorth_name} already exists."
      else
        all[@foorth_name]  = self
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
    #* foorth_name - The foorth_name of the new sub-class.
    #* class_class - The foorth_class of the class being created. This must be
    #  derived from the class Class or really weird stuff is going to happen.
    #  If omitted, this will default to the Class class.
    #* base_class - The Ruby class used to create this class and its subclasses.
    #  If omitted, the base_class of class_class will be used. If class_class
    #  is also omitted, then XClass will be used.
    #<br>Note:
    #* If a sub-class with the given name already exists, that class is returned.
    def create_foorth_subclass(foorth_name, class_class=nil, base_class=nil)
      class_class ||= self.foorth_class
      base_class  ||= (class_class && class_class.class_base_class) || self.class_base_class

      anon = Class.new(base_class) {@foorth_class = class_class}

      new_class = anon.new(foorth_name, self)

      XfOOrth.const_set('XfOOrth_' + foorth_name, anon) #Anonymous no longer!
      foorth_child_classes[foorth_name] = new_class
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
