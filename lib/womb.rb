class Womb < BasicObject
  def self.[](obj)
    new(obj)
  end

  def initialize(obj)
    @obj = obj
    @messages = []
  end

  def method_missing(method, *args, &b)
    method = aliases[method] || method
    return super unless obj.respond_to?(method, true)
    @messages << [obj, [method, *args], b]
    self
  end

  def init(*attributes)
    define_method(:initialize) do |*values|
      attributes.each_with_index do |attribute, i|
        instance_variable_set("@#{attribute}", values[i])
      end
    end
  end

  def send_to_singleton(*args, &b)
    @messages << [obj.singleton_class, args, b]
    self
  end

  def birth
    messages = @messages
    @obj.class_eval { messages.each { |(target, args, b)| target.send(*args, &b) } }
    @obj
  end

  private

  attr_reader :obj

  def aliases
    @aliases ||= { assign: :define_singleton_method,
                   def: :define_method }
  end
end
