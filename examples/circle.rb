require_relative '../lib/womb'

pi = 3.14

Circle = Womb[Class.new]
  .attr_reader(:radius)
  .define_method(:initialize) { |radius| @radius = radius }
  .define_method(:circumference) { 2 * pi * radius }
  .define_method(:area) { pi * radius ** 2 }
  .birth

puts Circle.new(3).area # 28.26
