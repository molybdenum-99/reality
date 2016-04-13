def Object.const_missing(name)
  Reality::Entity(name.to_s.gsub('_', ' '))
end

class Numeric
  BANNED_METHODS = %i[to_s to_str to_a to_ary to_h to_hash]
  
  def method_missing(name, *arg, &block)
    super unless arg.empty? && !block
    super if name =~ /\?!$/ || BANNED_METHODS.include?(name)

    Reality::Measure(self, name.to_s)
  end
end
