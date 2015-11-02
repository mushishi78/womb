require 'womb'

describe Womb do
  it 'can delegate missing methods' do
    obj = Womb[Class.new]
      .attr_accessor(:a)
      .define_method(:square) { a ** 2 }
      .birth
      .new

    obj.a = 3
    expect(obj.square).to eql(9)
  end

  it 'can use aliased method names' do
    obj = Womb[Module.new]
      .assign(:a){5}
      .assign(:b){12}
      .birth

    expect(obj.a).to eql(5)
    expect(obj.b).to eql(12)
  end

  it 'can initialize attributes' do
    obj = Womb[Class.new]
      .init(:a, :b)
      .def(:add) { @a + @b }
      .birth
      .new(3, 6)

    expect(obj.add).to eql(9)
  end

  it 'can send messages to singleton' do
    klass = Womb[Class.new]
      .init(:a)
      .assign(:build) { |a| new(a.to_s) }
      .send_to_singleton(:alias_method, :[], :build)
      .attr_reader(:a)
      .birth

    expect(klass.build(7).a).to eql('7')
    expect(klass[7].a).to eql('7')
  end

  it 'can use private for postceding definitions' do
    obj = Womb[Class.new]
      .private
      .def(:a){5}
      .birth
      .new

    expect { obj.a }.to raise_error(NoMethodError)
  end
end
