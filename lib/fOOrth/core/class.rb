# coding: utf-8

#* class.rb - The generic class class of the foorth language system.
module Xfoorth

  #The \XClass class is basis for all foorth classes.
  class XClass < XObject
    @all_classes  = Hash.new

    #Get the hash of all classes in the foorth system.
    def self.all_classes
      @all_classes
    end

    #Get the object class.
    def self.object_class
      @all_classes['Object']
    end

    #Get the class class.
    def self.class_class
      @all_classes['Class']
    end

    #Get the virtual machine class.
    def self.vm_class
      @all_classes['VirtualMachine']
    end

    #The base Ruby class for instances of this class.
    def instance_base_class
      XObject
    end

    #Delete all class objects. Needed for testing.
    def self._clear_all_classes
      XClass.all_classes.clear
    end

    #The name of the foorth class.
    attr_reader :name

    #The parent foorth class of this one.
    #<br>Special Cases:
    #* The \foorth_parent of the foorth class "Object" is nil.
    attr_reader :foorth_parent

    #A hash containing the methods defined for instances of this class.
    #<br>It maps (a symbol) => (a lambda block)
    attr_reader :dictionary

    #A hash containing all of the classes derived from this one.
    #<br>It maps (a class name) => (an object derived from \XClass)
    attr_reader :children

    #Create an new instance of a foorth class.
    #<br>Parameters:
    #* name - The name of this foorth class.
    #* \foorth_parent - The class that is the parent of this class.
    def initialize(name, foorth_parent)
      @name          = name
      @foorth_parent = foorth_parent
      @dictionary    = Hash.new
      @children      = Hash.new
      klass          = self

      all = XClass.all_classes

      if all.has_key?(@name)
        error "Class #{@name} already exists."
      else
        all[@name]  = self
      end

      @instance_template = Class.new(self.instance_base_class) do
        @foorth_class = klass
      end
    end

    #Set the class's parent class for the case where this can not be done
    #when the class is constructed. The parent may only be set once.
    def set_foorth_parent(foorth_parent)
      error "The class parent is already set" if @foorth_parent
      @foorth_parent = foorth_parent
    end

    #Create a new foorth subclass of this class.
    #<br>Parameters:
    #* name - The name of the new sub-class.
    #<br>Note:
    #* If a sub-class with the given name already exists, that class is returned.
    def create_foorth_subclass(vm, name, class_base=XClass)
      anon = Class.new(class_base) {@foorth_class = XClass.class_class}
      new_class = anon.new(name, self)
      @children[name] = new_class
      new_class
    end

    #Create an instance of this foorth class.
    #<br>Parameters:
    #* vm - The current foorth virtual machine.
    def create_foorth_instance(vm)
      obj = @instance_template.new
      obj.init(vm)
      obj
    end

    #Search the object class dictionaries for the named instance method and add
    #it to the target class.
    #<br>Parameters:
    #* name - The symbol of the method name to be added.
    #* target_class - The class to which the method is added.
    #<br>Returns:
    #* True on success else false if name could not be found.
    #<br>Endemic Code Smells
    # :reek:FeatureEnvy
    def link_shared_method(name, target_class)
      current = self

      while current
        dictionary = current.dictionary

        if dictionary.has_key?(name)
          target_class.cache_shared_method(name, &dictionary[name])
          return true
        end

        current = current.foorth_parent
      end

      false
    end

    #Add an instance method to this foorth class.
    #<br>Parameters:
    #* symbol - The method symbol to be added.
    #* block - The block associated with this method.
    #<br>Note:
    #* The method cache for this symbol is purged for this class and all child
    #  classes except where the child classes already have there own method.
    def add_shared_method(symbol, &block)
      @dictionary.delete(symbol)
      purge_shared_method(symbol)
      @dictionary[symbol] = block
    end

    #Purge the instance method cache for the specified symbol.
    def purge_shared_method(symbol)
      unless @dictionary.has_key?(symbol)
        @instance_template.purge_method(symbol)
        @children.each {|name, child| child.purge_shared_method(symbol)}
      end
    end
  end
end
