require_relative '../lib/womb'

Chain = Womb[Class.new]
  .init(:value)
  .attr_reader(:value)
  .send_to_singleton(:alias_method, :[], :new)
  .def(:>>) { |fn| @value = fn.to_proc.(value); self }
  .def(:<<) { |fn| fn.to_proc.(value); self }
  .def(:|) { |fn| fn.to_proc.(self) }
  .birth

double = ->(v) { v * 2 }
log = ->(v) { puts v }

res = Chain[3] >> double >> :next << log >> double << log >> :next | :value
# 7
# 14
puts res # 15
