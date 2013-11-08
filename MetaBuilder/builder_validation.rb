class BuilderValidation
  attr_accessor :name, :block
  def initialize (name, block)
    @name = name
    @block = block
  end

  def validate(instance)
    raise BuilderValidatorException.new("Error en la validacion: #{@name}") unless instance.instance_eval &@block
  end
end


class BuilderValidatorException < Exception

end