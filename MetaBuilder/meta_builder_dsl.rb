class MetaBuilderDSL
  def initialize metabuilder
    @metabuilder = metabuilder
  end

  def build (&block)
    self.instance_eval &block
  end

  def property(str)
    @metabuilder.addProperty str
  end

  def targetClass(klass)
    @metabuilder.setTargetClass klass
  end

  def validate(name, &block)
    @metabuilder.addValidation(name, &block)
  end

  def behaveWhen(method, hash_blocks)
    @metabuilder.addBehaviour(method, hash_blocks[:condition], hash_blocks[:behaviour])
  end


end