# Womb

`Womb` wraps around an object to present a chainable interface for defining
objects. It also provides short aliases for longer method names and helpers to
reduce boiler plate.

## Usage

Once wrapped around an object, `Womb` stores all messages via `method_missing`
and then sends them to the object when the `birth` method is called, returning
the defined object.

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
require 'git'

Repo = Womb[Class.new]
  .assign(:open) { |path| new(Git.open(path)) }
  .assign(:clone) { |url, path| new(Git.clone(url, path)) }
  .init(:git)
  .def(:checkout) { |branch| git.checkout(branch); self }
  .def(:branch) { |branch| git.branch(branch).checkout; self }
  .def(:add) { git.add(all: true); self }
  .def(:commit) { |message| git.commit(message); self }
  .def(:push) { git.push('origin', git.current_branch, force: true); self }
  .def(:ls) { add; git.ls_files.keys }
  .private
  .attr_reader(:git)
  .birth

Repo.open('../my_local_repo').add.commit('Updating with changes').push
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
