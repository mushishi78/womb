require_relative '../lib/womb'

Matrix = Womb[Class.new]
  .init(:v1, :v2)
  .attr_reader(:v1, :v2)
  .send_to_singleton(:alias_method, :[], :new)
  .def(:determinant) { v1[0] * v2[1] - v2[0] * v1[1] }
  .birth

puts Matrix[[2, 2], [1, 3]].determinant # 4
