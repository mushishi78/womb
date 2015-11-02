class Womb < BasicObject
  def self.[](obj)
    new(obj)
  end

  def initialize(obj)
    @obj = obj
  end

  def method_missing(name, *args, &b)
    obj.send(aliases[name] || name, *args, &b)
    self
  end

  def init(*attributes)
    define_method(:initialize) do |*values|
      attributes.each_with_index do |attribute, i|
        instance_variable_set("@#{attribute}", values[i])
      end
    end
  end

  def send_to_singleton(*args)
    obj.singleton_class.send(*args)
    self
  end

  def birth
    @obj
  end

  private

  attr_reader :obj

  def aliases
    @aliases ||= { assign: :define_singleton_method,
                   def: :define_method }
  end

end
