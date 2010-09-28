#!/usr/bin/env ruby

#require 'rubygems'#require 'daemons'
#Daemons.run 'myserver.rb'

# ln -s  serpent-server.rb  ssserver
# ssserver [command]
#   start 8
#   pause sleep
#   status
#   run = foreground
#   pack results in output to output/backup or batches/
# dir where started - 
# dir where located - ? log and stop - no otherwise no multiple servers

# def SerpentServer.log message
#   LOG = File.exists? 'serpent-server.log' ? Kernel.open 'serpent-server.log' : File.new 'serpent-server.log'
# end

# serpent-server.rb stop -> touch serpent-server.stop
if ARGV[1] == 'stop'
  Kernel.system 'touch serpent-server.stop'
  Kernel.exit
end


if ARGV.include? 'start' # start or run in foreground
  # run in background
end

# register server in the list


# clean working dir? y/n/exit
# create? input/ output/ recovered/  input/batch-name/  queue/batch/
# sort by date?


wait = false
until File.exists? 'serpent-server.stop'

  # find input files
  list = Dir.glob('input/*').select { |f| File.file? f }

  if list.empty?
    puts "Waiting for inputs..." unless wait
    wait = true    
    # wait a little
    Kernel.sleep 3
    next
  else
    puts((wait ? "Found inputs: " : "Inputs in queue: ") + list.count.to_s)
    wait = false
  end

  # sort by file date, choose the oldest
  # choose the first file
  input = File.basename list.first


  Kernel.sleep 3 # in case if it is being copied

  # clean if similar exist
  Dir.glob(input + '*').each do |ff|
  end

  #File.move list.first, './'
  Kernel.system "mv input/#{input} ./"

  # start in a thread if finished but before zip results
  puts "Running #{input} ..."
  Kernel.system "sss -mpi 7 #{input} > #{input}.log"
  puts "  ...done."

  Kernel.system "mv #{input}* output/"
  puts "  results moved to ./output/"
end

# stop run if running

Kernel.system 'rm serpent-server.stop'

