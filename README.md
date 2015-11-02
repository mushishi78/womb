# Womb

`Womb` wraps around an object to present a chainable interface for defining
objects. It also provides short aliases for longer method names and helpers to
reduce boiler plate.

## Usage

Once wrapped around an object, `Womb` forwards messages via `method_missing` to
the object. All forwarded messages are sent with the `send` method, such that
normally private methods such as `attr_accessor` and `define_method` can be
used. After the object has been defined, the `birth` method returns the
object.

``` ruby
require 'womb'

pi = 3.14

Circle = Womb[Class.new]
  .attr_reader(:radius)
  .define_method(:initialize) { |radius| @radius = radius }
  .define_method(:circumference) { 2 * pi * radius }
  .define_method(:area) { pi * radius ** 2 }
  .birth

Circle.new(3).area # 28.26
```

For shorthand, `def` and `assign` can be used as aliases for `define_method`
and `define_singleton_method` respectively, and `init` can be used to create
an `initialize` method that simply sets instance variables from it's arguments.

``` ruby
RegPolygon = Womb[Module.new]
  .assign(:interior_angle) { |sides| (sides - 2) * Math::PI / sides }
  .birth

Triangle = Womb[Module.new]
  .assign(:area) { |base, height| base * height / 2 }
  .birth

RegTriangle = Womb[Class.new]
  .init(:base)
  .def(:height) { @base * Math.sin(RegPolygon.interior_angle(3)) }
  .def(:area) { Triangle.area(@base, height) }
  .birth

RegTriangle.new(2).area # 1.7320508075688772
```

An additional helper, `send_to_singleton`, can be used to send messages to the
object's singleton class.

``` ruby
Matrix = Womb[Class.new]
  .init(:v1, :v2)
  .attr_reader(:v1, :v2)
  .send_to_singleton(:alias_method, :[], :new)
  .def(:determinant) { v1[0] * v2[1] - v2[0] * v1[1] }
  .birth

Matrix[[2, 2], [1, 3]].determinant # 4
```

If you prefer not to define a method with a block directly, it can defined as
a lambda and passed in using the `to_proc` operator, `&`. The objects private
state can still be accessed with instance variables.

``` ruby
move = ->(dist, angle) do
  angle = angle * Math::PI / 180
  @x += dist * Math.cos(angle)
  @y += dist * Math.sin(angle)
  puts self
  self
end

Turtle = Womb[Class.new]
  .init(:x, :y)
  .def(:move, &move)
  .def(:to_s) { "Turtle (#{@x.round}, #{@y.round})" }
  .birth

Turtle.new(0, 0).move(1, 0).move(2, 90)
# Turtle (1, 0)
# Turtle (1, 2)
```

## Installation

Add your Gemfile:

```ruby
gem 'womb'
```

## Contributing

1. [Fork it]( https://github.com/mushishi78/womb/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
