require_relative '../lib/womb'

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
