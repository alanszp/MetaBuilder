require_relative '../MetaBuilder/builder'
require_relative '../MetaBuilder/meta_builder'
require 'rspec'


describe 'Test de Metabuilder' do
  before do
    class Perro
      attr_accessor :raza, :edad, :peso

      def paciencia_duenio
        50
      end
    end
  end

  it 'pasa si construye bien el objeto' do
    metaBuilder = MetaBuilder.new
    metaBuilder.addProperty('raza')
    metaBuilder.addProperty('edad')
    metaBuilder.addProperty('peso')
    metaBuilder.setTargetClass(Perro)

    builderDePerros = metaBuilder.build
    builderDePerros.edad = 4
    builderDePerros.peso = 14
    builderDePerros.raza = 'fox terrier'


    perro = builderDePerros.build

    expect(perro.raza).to eq('fox terrier')
    expect(perro.edad).to eq(4)
    expect(perro.peso).to eq(14)
  end

  it 'pasa si construye el objeto con un dsl' do
    builderDePerros = MetaBuilder.build {
                        property('raza')
                        property('edad')
                        property('peso')
                        targetClass(Perro)
                      }

    perro = builderDePerros.buid(edad: 4, peso:14, raza: 'fox terrier')

    expect(perro.raza).to eq('fox terrier')
    expect(perro.edad).to eq(4)
    expect(perro.peso).to eq(14)

  end

  it 'pasa si construye el validandolo' do
    builderDePerros = MetaBuilder.build {
      property('raza')
      property('edad')
      property('peso')
      targetClass(Perro)
      validate 'Raza' do
        ['fox terrier', 'salchica', 'chiuaua'].include? raza
      end

      validate 'Edad' do
        edad > 0 && edad < 20
      end
    }

    perro = builderDePerros.buid(edad: 4, peso:14, raza: 'fox terrier')

    expect(perro.raza).to eq('fox terrier')
    expect(perro.edad).to eq(4)
    expect(perro.peso).to eq(14)

  end

  it 'pasa si lanza excepcion por raza al validar' do
    builderDePerros = MetaBuilder.build {
      property('raza')
      property('edad')
      property('peso')
      targetClass(Perro)
      validate 'Raza' do
        ['fox terrier', 'salchica', 'chiuaua'].include? raza
      end

      validate 'Edad' do
        edad > 0 && edad < 20
      end

    }

    expect{
      builderDePerros.buid(edad: 8, peso:14, raza: 'foxa terrier')
    }.to raise_error(BuilderValidatorException)

  end


  it 'pasa si construye agregando comportamiento' do
    builderDePerros = MetaBuilder.build {
      property('raza')
      property('edad')
      property('peso')
      targetClass(Perro)

      behaveWhen'expectativaVida', condition: proc { raza == 'fox terrier' }, behaviour:proc {20 - edad}

      behaveWhen'expectativaVida', condition: proc { raza == 'salchicha' }, behaviour: proc {edad + peso * 2}

      behaveWhen'expectativaVida', condition: proc { raza == 'chiuaua' }, behaviour: proc { 20 - edad}
    }

    perro = builderDePerros.buid edad: 4, peso:14, raza: 'fox terrier'

    expect(perro.expectativaVida).to eq(16)
  end

  it 'pasa si construye agregando comportamiento' do
    builderDePerros = MetaBuilder.build {
      property 'raza'
      property 'edad'
      property 'peso'
      targetClass Perro

      behaveWhen'expectativaVida', condition: proc { raza == 'fox terrier' }, behaviour:proc {
        20 - edad
      }

      behaveWhen'expectativaVida', condition: proc { raza == 'salchicha' }, behaviour: proc {
        edad + peso * 2
      }

      behaveWhen'expectativaVida', condition: proc { raza == 'chiuaua' }, behaviour: proc {
        20 - edad
      }
    }

    perro = builderDePerros.buid edad: 4,
                                 peso:14,
                                 raza: 'pato donald'

    expect{ perro.expectativaVida }.to raise_error(NoMethodError)
  end

end