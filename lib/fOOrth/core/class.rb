#* class.rb - The generic class class of the fOOrth language system.
module XfOOrth

  #The \XClass class is basis for all fOOrth classes.
  class XClass < XObject
    @all_classes  = Hash.new

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
      XfOOrthObject
    end

    #Delete all class objects. Needed for testing.
    def XfOOrthClass._clear_all_classes
      XClass.all_classes.clear
    end

    #Create the initial classes in the fOOrth hierarchy.
    def XfOOrthClass.initialize_classes
      class_anon = Class.new(XfOOrthClass) {@fOOrth_class = nil}
      class_class = class_anon.new('Class', nil)
      class_anon.fOOrth_class = class_class

      object_anon = Class.new(XfOOrthClass) {@fOOrth_class = class_class}
      object_class = object_anon.new('Object', nil)
      object_class.add_shared_method(:init) {|vm| }
      object_class.children['Class'] = class_class

      class_class.set_fOOrth_parent(object_class)
    end

    #The name of the fOOrth class.
    attr_reader :name

    #The parent fOOrth class of this one.
    #<br>Special Cases:
    #* The \fOOrth_parent of the fOOrth class "Object" is nil.
    attr_reader :fOOrth_parent

    #A hash containing the methods defined for instances of this class.
    #<br>It maps (a symbol) => (a lambda block)
    attr_reader :dictionary

    #A hash containing all of the classes derived from this one.
    #<br>It maps (a class name) => (an object derived from \XfOOrthClass)
    attr_reader :children

    #Create an new instance of a fOOrth class.
    #<br>Parameters:
    #* name - The name of this fOOrth class.
    #* \fOOrth_parent - The class that is the parent of this class.
    def initialize(name, fOOrth_parent)
      @name          = name
      @fOOrth_parent = fOOrth_parent
      @dictionary    = Hash.new
      @children      = Hash.new
      klass          = self

      if XClass.all_classes.has_key?(@name)
        error 'Class #{@name} already exists.'
      end

      XClass.all_classes[@name]  = self

      @instance_template = Class.new(self.instance_base_class) do
        @fOOrth_class = klass
      end
    end

    #Set the class's parent class for the case where this can not be done
    #when the class is constructed. The parent may only be set once.
    def set_fOOrth_parent(fOOrth_parent)
      error "The class parent is already set" if @fOOrth_parent
      @fOOrth_parent = fOOrth_parent
    end

    #Create a new fOOrth subclass of this class.
    #<br>Parameters:
    #* vm - The current fOOrth virtual machine.
    #* name - The name of the new sub-class.
    #* block - An optional class initialization block that takes the vm as
    #  an argument.
    #<br>Note:
    #* If a sub-class with the given name already exists, that class is returned.
    def create_fOOrth_subclass(vm, name, class_base=XfOOrthClass, &block)
      anon = Class.new(class_base) {@fOOrth_class = XfOOrthClass.class_class}
      new_class = anon.new(name, self)

      @children[name] = new_class
      new_class.instance_exec(vm, &block) if block
      new_class
    end

    #Create an instance of this fOOrth class.
    #<br>Parameters:
    #* vm - The current fOOrth virtual machine.
    def create_fOOrth_instance(vm)
      obj = @instance_template.new
      obj.init(vm)  # <<< ????? I'm not sure about this!!!
      obj
    end

    #Search the object class dictionaries for the named instance method and add
    #it to the target class.
    #<br>Parameters:
    #* name - The symbol of the method name to be added.
    #* target_class - The class to which the method is added.
    #<br>Returns:
    #* True on success else false if name could not be found.
    def link_shared_method(name, target_class)
      current = self

      while current
        dictionary = current.dictionary

        if dictionary.has_key?(name)
          target_class.cache_shared_method(name, &dictionary[name])
          return true
        end

        current = current.fOOrth_parent
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
