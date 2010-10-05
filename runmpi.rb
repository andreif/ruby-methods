#!/usr/bin/env ruby
# Examples:
# runmpi 10x4 11x2 12x2 14x2 16x2 mcnpx n= input
# (master doesn't accept tasks for the moment)

args = ARGV.dup

hostfile = ''
until args.empty?  
  case args.first
    when 'bg' then $background = true
    when /^(\d+)x(\d)$/ then $2.to_i.times { hostfile << ("node%04d\n" % $1) }
    when /^mx(\d)$/ then $1.to_i.times { hostfile << "WWmaster\n" }
  else
    break
  end
  args.shift
end

Kernel.puts "Running task on nodes: \n" + hostfile.strip.gsub("\n", ', ')

loop do
  $hostfile_path = ENV['HOME'] + '/hostfile.' + (('0'..'9').to_a + ('A'..'Z').to_a + ('a'..'z').to_a).sample(5).join
  break unless File.exists? $hostfile_path
end

File.open($hostfile_path,'w+') do |f|
  f.write hostfile
end

cmd = "mpirun -hostfile %s -np %d %s" % [ $hostfile_path, hostfile.strip.split("\n").count, args.join(' ') ]
Kernel.puts "Command: " + cmd
if $background
  Kernel.puts "starting in background..."
  Kernel.system "at now <<!\n%s > runmpi.log\nrm %s\n!" % [cmd, $hostfile_path]
else
  Kernel.system cmd
  File.delete $hostfile_path
end



