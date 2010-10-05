#!/usr/bin/env ruby
# Examples:
# nodes m 0..21 -14 0..6 7..8 14
# nodes all

all = 0..20
all.each do |i|
  Kernel.system ("alias n%d='ssh node%04d'" % i)
end

nodes = []
ARGV.each do |a|
  case a
  when /^(\d+)\.\.(\d+)$/ then
    ($1.to_i..$2.to_i).each do |n|
      nodes.push 
    end
  when /^-\d+$/ then 
  when /^\d+$/  then 
  when '-m'     then master = false
  when 'm'      then master = true
  when 'all'    then nodes = all.to_a
end
nodes = ENV['NODES'] if nodes.empty?

export NODES="WWmaster"

alias ALLNODES="export NODES='node0000,node0001,node0002,node0003,node0004,node0005,node0006,node0007,node0008,node0009,node0010,node0011,node0012,node0013,node0014,node0015,node0016,node0017,node0018,node0019,node0020,node0021'"

alias OURNODES="export NODES='node0007,node0008,node0009,node0010,node0011,node0012,node0013'"

OURNODES