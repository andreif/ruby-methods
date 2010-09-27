=begin

@lead_density

next generation math:
 - each variable must be accompanied with description/help, unit, and uncertainty
 - each derived variable remembers the way it was defined (is a function of other parameters),
     gets simplified unit, and propagated uncertainties.

Parameter properties:
 - name
 - complex expression - function definition
 - current value
 - preferred unit to print
 - uncertainty (absolute and/or relative?) - propagation expression
 - description, comment, help
 - short notation
 

online calc?

functional dependence like in Mathematica

if parameter not found then show the closest matches in case of typo "did you mean..."

sort by unit groups - dimensions, areas, volumes

short notations - aliases:
 "R, pin radius"
 "pin radius, R"
 - check if two parameters have the same alias

=end

module ResearchSpace
  
  class Model
    attr_accessor :params
    
    class Parameter
      attr_accessor :name, :expression, :unit, :comment
      def initialize *args
        @name, @expression, @unit, @comment = args
      end
    end
    
    
    def initialize text=nil
      @params = {}
      self.parse text unless text.nil?
    end
    
    
    def parse text
      text.strip.split(/\n\s*/).each do |line|
        line,comment = line.strip.split('#')
        next if line.empty?
        key,expr = line.gsub(/_|  +/,' ').strip.split(/\s+=\s+/)
# p parse:key
        unless key.nil?
          key,unit = key.split '['
          unless unit.nil?
            unit,t = unit.split ']'
            unit.strip!
            key.strip!
          end
        end
        if unit.nil? and not expr.nil? and expr =~ /[0-9.]+\s+([^\s]+)$/
          unit = $1
        end
        if expr.nil? or expr.empty?
          self[key,unit] = nil unless key.nil?
        else
          self[key,unit] = expr
        end
        @params[key].comment = comment
      end
    end
    
    
    def eval_expr long_expr, result_unit=nil
      result = ''
      long_expr.to_s.split(/\s+([\+\-\*\\\^])\s+/).each_slice(2) do |part|
        expr, operator = part
#p eval:expr
        if expr =~ /^\d/
          value, unit = expr.split
          expr = Kernel.eval(value).to_f * self.eval_unit(unit || result_unit)
        else
# p eval:self.has?(expr)
          expr = self[expr.strip]
        end
        result += expr.to_s + operator.to_s
      end
      pi = Math::PI
#p eval:[result, result_unit, self.eval_unit(result_unit)]
      return Kernel.eval(result)
    end
    
    # C -> K conversion ?
    def eval_unit expr
      return 1.0 if expr.nil? or expr.strip.empty?
      # base SI units
      m = _K = _J = s = 1.0
      # derived units
      _W = _J/s
      # orders
      cm = m / 100
      mm = m / 1000
      # constants
      pi = Math::PI
      return Kernel.eval expr.gsub('%','0.01').gsub(/([A-Z]+)/, "_\\1").gsub('^','**')
    end
    
    
    def print indent=nil
      sz = @params.keys.collect { |key| key.length }.max
      r = ''
      @params.each do |key,param|
# p print:key
        value = self.eval_expr(param.expression || key, param.unit) / self.eval_unit(param.unit)
        value = value.to_i if value == value.to_i
        r += "%s%#{sz}s =  %-15s  %s\n" % [
          indent, 
          key, 
          "%s %s" % [value, param.unit], 
          param.comment
        ]
      end
      return r
    end
    
    def calc *keys
      keys.flatten.each do |key|
        #self[key] = key # self[key]
      end
    end
    
    
    def []= *args
      case args.count
        when 2 then key,expr = args; unit = nil
        when 3 then key,unit,expr = args
      else raise end
      @params[key] = Parameter.new key, expr, unit
    end
    
    
    def has? key; @params.has_key?(key) && !@params[key].expression.nil? end
    
    
    def [] key
# p :[] => key
      if self.has? key
        return self.eval_expr @params[key].expression, @params[key].unit
      else
        return self.try_to_calc key
      end
    end
    
    
    def try_to_calc key, tried_keys=[]
#p key
      if self.has? key
        return self[key]
      else
        tried_keys << key
      end
      case key
        when / area$/
        when / volume$/
          # @params[key.gsub(/radius$/,'area')] = Math::PI * @params[key]**2
          # @params[key.gsub(/radius$/,'area')] = Math::PI * @params[key]**2 / 4
          #when / outer radius$/
          #when / outer radius$/
        when r = / radius$/
          if not tried_keys.include?(next_try = key.gsub(r,' diameter'))
            return self.try_to_calc(next_try, tried_keys).to_f / 2.0
            
          elsif not tried_keys.include?(next_try = key.gsub(r,' outer radius')) and not next_try =~ /outer outer/
            return self.try_to_calc(next_try, tried_keys).to_f
            
          end
            
        when r = / diameter$/
          if not tried_keys.include?( next_try = key.gsub(r,' radius'))
            return self.try_to_calc(next_try, tried_keys).to_f * 2.0
            
          elsif not tried_keys.include?(next_try = key.gsub(r,' outer diameter')) and not next_try =~ /outer outer/
            return self.try_to_calc(next_try, tried_keys).to_f
            
          end
      end
      raise "Paramater is missing: " + tried_keys.first
    end
  end
  

  class ModelObject
  end

  class Material
  end

end