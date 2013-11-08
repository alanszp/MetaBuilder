class Builder
  attr_accessor :metabuilder

  def initialize meta
    @metabuilder = meta
  end

  def build
    @metabuilder.add_properties(@metabuilder.targetClass)

    instance = @metabuilder.targetClass.new

    fill_instance(instance)

    validate(instance)

    add_behaviour(instance)

    instance
  end

  def fill_instance(instance)
    @metabuilder.properties.each do |property|
      instance.send ("#{property}="), (self.send property)
    end
  end

  def validate(instance)
    @metabuilder.validations.each do |validation|
      validation.validate(instance)
    end
  end

  def add_behaviour(instance)
    @metabuilder.behaviours.each do |behaviour|
      behaviour.to(instance)
    end
  end

  def buid(args)
    args.each do |method, value|
      instance_eval do
        send "#{method}=", value
      end
    end

    build
  end
end
