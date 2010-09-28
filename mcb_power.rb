# mcb_power('50e6 1y 4, 0e0 1y 10')
def mcb_power text
  powers = periods = ''
  text.split(',').each do |part|
    power,period,n = part.split
    period.gsub! /^(.*\d)([a-z])$/, '\\1 \\2'
    n.to_i.times do
      sz = [power.length, period.length].max + 1
      powers += "%-#{sz}s" % power
      periods += "%-#{sz}s" % period
    end
  end
  return "power %s \npriod %s" % [powers, periods]
  # power = []
  # curr_time = 0
  # args.each do |s|
  #   p,t,dt = s.split.collect { |v| v.to_f }
  #   #until t
  #   #power.push
  # end
end