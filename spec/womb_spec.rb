require 'womb'

describe Womb do
  it 'can delegate missing methods' do
    obj = Womb[Class.new]
      .attr_accessor(:a, :b)
      .private(:a, :b)
      .define_method(:add) { a + b }
      .birth
      .new

    obj.a = 35
    obj.b = 9
    expect { obj.a }.to raise_error(NoMethodError)
    expect(obj.add).to eql(44)
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
      .send_to_singleton(:alias_method, :[], :new)
      .attr_reader(:a)
      .birth

    instance = klass[7]
    expect(instance.a).to eql(7)
  end
end
