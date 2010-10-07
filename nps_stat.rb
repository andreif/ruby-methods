require :time
$nps_stat_details = true
def nps_stat_print curr_time, prev_time, curr_nps, prev_nps, tasks = nil
  dt = curr_time - prev_time
  puts "%s-%s = %2d:%02d:%02d, %5s-%-5s = %5s,  %.2f n/sec = 1000 n / %5.1f min,  %3.0f n/1000/s/task" % [
    prev_time.strftime('%H:%M:%S'), 
    curr_time.strftime('%H:%M:%S'),
    dt/3600, dt%3600/60, dt%600%60,
    prev_nps.zero? ? nil : curr_nps,
    prev_nps.zero? ? nil : prev_nps,
    dn = curr_nps - prev_nps,
    r = dn/dt,
    1000/r/60,
    r/tasks*1000#1/r*tasks
  ]
end
def nps_stat log
  prev_nps = 0; start_time = prev_time = curr_time = curr_nps = nil
  puts '='*105 if $nps_stat_details
  puts (tasks = log.scan(/master starting\s+(\d+)(.+)$/).flatten).join.gsub(/  +/,' ') rescue nil
  tasks = tasks.first.to_i
  tasks += 1 if log =~ /rendezvous at/ # mcnpx correction
  puts '-'*105 if $nps_stat_details
  log.scan(/(master set )?rendezvous( at)? nps =\s+(\d+)\s+(# of microtasks =\s+\d+)?(.*)$/).each do |s|
    next_nps = s[2].to_i
    curr_time = Time.parse s.last.gsub(/(\d+)(\/\d+)(\/\d+)/,'\\1\\3\\2')
    if start_time
      nps_stat_print curr_time, prev_time, curr_nps, prev_nps, tasks if $nps_stat_details
      prev_nps = curr_nps
    end
    start_time ||= curr_time
    prev_time = curr_time
    curr_nps = next_nps
  end
  puts '-'*105 if $nps_stat_details
  nps_stat_print curr_time, start_time, prev_nps, 0, tasks
  puts "\n"
end


