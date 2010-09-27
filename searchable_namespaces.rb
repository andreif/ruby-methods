# class String
# def to_class
#   chain = self.split "::"
#   klass = Kernel
#   chain.each do |klass_string|
#     klass = klass.const_get klass_string
#   end
#   klass.is_a?(Class) ? klass : nil
# rescue NameError
#   nil
# end
# end

class String
  def to_class
    self.split('::').inject(Object) do |mod, class_name|
      mod.const_get(class_name)
    end
  end
end


def Object.const_missing(name)
  @looked_for ||= {}
  key = self.to_s + '~' + name.to_s
  raise "Class not found: #{name}" if @looked_for[key] == key
  return @looked_for[key] if @looked_for[key]
  @looked_for[key] = key
#p [@looked_for, name]
  if self.to_s.include? '::'
    klass = Object
    self.to_s.split('::')[0..-2].each_with_index do |klass_string,i|
      klass = klass.const_get klass_string
#p [i, klass, klass.constants]
    end
#p [klass, klass.constants, name]
    return @looked_for[key] = klass.const_get(name) if klass # klass.is_a?(Class)
  end
  raise "Class not found: #{name}"
end


# class A
#   class B
#     class C
#     end
#   end
#   class BB
#   end
# end
# 
# class A::B::D < A::C
#   def initialize
#     BB.new
#   end
# end
# 
# 
# p "A::B::C".to_class
# p "A::B::D".to_class
# p A::B::D.new



# class A
# end
# 
# class A::B
# end
# 
# class A::C
#   def initialize
#     p B.new
#   end
# end
# 
# class A
#   class D
#     def initialize
#       p B.new
#     end
#   end
# end
# 
# A::D.new
# A::C.new








