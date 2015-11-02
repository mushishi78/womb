require_relative '../lib/womb'

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

puts RegTriangle.new(2).area # 1.732050807568877
