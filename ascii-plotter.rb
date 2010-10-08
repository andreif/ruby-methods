#!/usr/bin/env ruby
# (c) 2010, Andrei Fokau (andrei.fokau@neutron.kth.se)

class ASCII_Plotter
  def initialize data_xy, w = 120, h = 28
    @height = h
    @width = w
    @data = data_xy
    self.set_limits
    self.set_points
    Kernel.puts @plot
  end
  def set_limits
    @x = []
    @y = []
    @data.each do |xy|
      x,y = xy
      @x << x
      @y << y
    end
  end
  def set_points
    @plot = ((' '*@width))*(@height+1)
#p @plot.length
    x_min,x_max = @x.minmax
    y_min,y_max = @y.minmax
    dw = (x_max - x_min).to_f / @width
    dh = (y_max - y_min).to_f / @height
    @data.each_with_index do |xy,i|
      x,y = xy
      w = ((x.to_f - x_min) / dw).round
      h = ((y.to_f - y_min) / dh).round
#p [h,y, y_min,(y - y_min)]
      h = @height - h
      pos = (h)*(@width) + w
      pos -= 1 if w == @width # correction
#p [x,y,w,h,pos]
      @plot[pos.to_i] = 'x'
    end
    @plot = @plot.scan(/.{1,#{@width}}/).join("\n")
  end
end

#  test
# ASCII_Plotter.new([
#   [1,1],
#   [5,5],
#   [10,10],
#   [15,15],
#   [20,20],
#   [25,25],
#   [30,30],
#   [1,30],
#   [30,1]
# ], 28)