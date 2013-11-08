class Behaviour
  attr_reader :method, :condition, :block
  def initialize(method, condition, block)
    @method = method
    @condition = condition
    @block = block
  end

  def apply(instance)
    instance.instance_eval &condition
  end

  def inject(instance)
    instance.define_singleton_method @method, &@block
  end

  def to(instance)
    inject(instance) if apply(instance)
  end
end