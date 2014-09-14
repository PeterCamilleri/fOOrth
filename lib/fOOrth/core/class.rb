# coding: utf-8

#* core/class.rb - The generic class class of the fOOrth language system.
module XfOOrth

  #The \XClass class is basis for all fOOrth classes.
  class XClass < XObject

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

    #A hash containing the methods defined for instances of this class.
    #<br>It maps (a symbol) => (a lambda block)
    attr_reader :dictionary

    #A hash containing all of the classes derived from this one.
    #<br>It maps (a class name) => (an object derived from \XClass)
    attr_reader :children

    #Create an new instance of a fOOrth class.
    #<br>Parameters:
    #* name - The name of this fOOrth class.
    #* \foorth_parent - The class that is the parent of this class.
    def initialize(name, foorth_parent)
      @name          = name
      @foorth_parent = foorth_parent
      @dictionary    = Hash.new
      @children      = Hash.new
      klass          = self

      all = XfOOrth.all_classes

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

    #Create a new fOOrth subclass of this class.
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

    #Create an instance of this fOOrth class.
    #<br>Parameters:
    #* vm - The current fOOrth virtual machine.
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

    #Add an instance method to this fOOrth class.
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
