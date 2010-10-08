#!/usr/bin/env ruby
# (c) 2010, Andrei Fokau (andrei.fokau@neutron.kth.se)

class MCNP
  class Performance
    
    TIMESTAMP = /(master set )?rendezvous( at)? nps =\s+(\d+)\s*(# of microtasks =\s+\d+)?\s*(.*)$/
    
    def initialize log_path
      @filepath = log_path
      @text = IO.read log_path
      self.get_tasks
      self.get_timestamps
      self.get_dumps
      self.print
      self.plot
    end
    
    def print
      Kernel.puts "\n  MCNP Performance\n\n"
      self.print_info
      self.print_matlab
      Kernel.puts "\n"
    end
    
    def plot
      begin
#p File.dirname(__FILE__)
        #(require 'ascii-plotter.rb') rescue (require './ascii-plotter.rb') rescue (require File.join( File.dirname(__FILE__), '/ascii-plotter.rb'))
        data_xy = []
        start_time = @timestamps.first[-2]
        @timestamps.each do |ts|
          i,n1,n0,t1,t0,dn_dt = ts
          data_xy << [(t1-start_time)/60/60, dn_dt]
        end
        ASCII_Plotter.new(data_xy)
      rescue
        Kernel.puts "Warning: 'ascii-plotter.rb' was not found by Ruby. Update path variables if necessary."
      end
    end
    
    def print_info
      fmt = '%7.2e nps/sec/task'
      r = ''
      first = last = min = max = nil
      @timestamps.each do |ts|
        i,n1,n0,t1,t0,dn_dt = ts
        last = [i, t1.strftime('%a %d %b %Y %H:%M:%S'), dn_dt]
        first ||= last
        max = last if max.nil? or max.last < dn_dt
        min = last if min.nil? or min.last > dn_dt
        r << "%s  #{fmt}\n" % [t1, dn_dt]
      end
      @dumps.each do |dm|
        r << "dump %s %s\n" % dm
      end
      rr =  "  frst: cycle %6d, %s, #{fmt}\n" % first
      rr << "  last: cycle %6d, %s, #{fmt}\n" % last
      rr << "  max:  cycle %6d, %s, #{fmt}\n" % max
      rr << "  min:  cycle %6d, %s, #{fmt}\n" % min
      rr << "  average performance: %25s#{fmt} \n\n" % [nil, 
        (@timestamps.inject(0) { |sum,el| sum.to_f + el.last } / @timestamps.count)
      ]
      Kernel.puts rr
      self.write 'Cycle data', (r+rr), '_perf.txt'
    end
    
    def write what, text, ext
      path = (ext =~ /\.m$/) ? @filepath.gsub('.','_') : @filepath
      File.open(path+ext,'w+').write text
      Kernel.puts "  %s written to %s" % [what, path+ext]
    end
    
    def get_tasks
      @tasks = @text.scan(/master starting\s+(\d+)(.+)$/).flatten.first.to_i rescue nil
      @tasks += 1 if @text =~ /rendezvous at/ # mcnpx correction
    end
    
    def get_timestamps
      require 'time'
      @prev_nps = 0
      @timestamps = []
      @text.scan(TIMESTAMP).each_with_index do |s,i|
        @next_nps = s[2].to_i
        @curr_time = Time.parse s.last.gsub(/(\d+)\/(\d+)\/(\d+)/,'20\\3-\\1-\\2') # date correction
        if @start_time
          @timestamps << [i,@curr_nps,@prev_nps, @curr_time,@prev_time, (@curr_nps-@prev_nps).to_f/(@curr_time-@prev_time)/@tasks]
          @prev_nps = @curr_nps
        end
        @start_time ||= @curr_time
        @prev_time = @curr_time
        @curr_nps = @next_nps
      end
    end
    
    def get_dumps
      @dumps = []
      @text.split(/ dump\s+(\d+) on file/)[3..-1].each_slice(2) do |dmp|
        @dumps << [dmp.first, $5] if dmp.last =~ TIMESTAMP
      end
    end
    
    def print_matlab
      start_time = @timestamps.first[-2]
      r = "data = [ % cycle nr., performance, time from start\n"
      @timestamps.each do |ts|
        i,n1,n0,t1,t0,dn_dt = ts
        r << "%6d,  %10e,  %10e ;\n" % [i, dn_dt, t1-start_time]
      end
      r << "];\n"
      r << "figure; plot(data(:,3)/60/60, data(:,2),'-','LineWidth',1.5); grid on; \nxlabel('Time, hours'); ylabel('Performace, nps/sec/task'); \ntitle('#{@filepath}','interpreter','none')"
      self.write 'Cycle data for MATLAB', r, '_perf.m'
    end
  end
end

class ASCII_Plotter
  def initialize data_xy, w = 120, h = 26
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

#MCNP::Performance.new('/Users/andrei/Workspace/Temp/mcnp_perf/input.log')
MCNP::Performance.new(ARGV.first)