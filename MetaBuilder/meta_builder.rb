require_relative '../MetaBuilder/builder'
require_relative '../MetaBuilder/meta_builder_dsl'
require_relative '../MetaBuilder/behaviour'
require_relative '../MetaBuilder/builder_validation'

class MetaBuilder
  attr_accessor :properties, :targetClass, :validations, :behaviours

  def initialize
    @properties = []
    @validations = []
    @behaviours = []
  end

  def self.build &block
    selfInstance = self.new
    MetaBuilderDSL.new(selfInstance).build(&block)
    selfInstance.build
  end

  def addProperty(property)
    @properties << property
  end

  def setTargetClass(klass)
    @targetClass = klass
  end

  def addValidation(name, &validation)
    @validations << BuilderValidation.new(name, validation)
  end

  def addBehaviour(method, proc_condition, block)
    @behaviours << Behaviour.new(method, proc_condition, block)
  end


  def build
    builder = Builder.new(self)

    add_properties(builder.singleton_class)

    builder
  end

  def add_properties(object)
    @properties.each do |property|
      object.send :attr_accessor, property.to_sym
    end
  end

end