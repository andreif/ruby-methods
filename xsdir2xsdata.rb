#!/usr/bin/env ruby
 
symbols = "n H He Li Be B C N O F Ne Na Mg Al Si P S Cl Ar K Ca Sc Ti V Cr Mn Fe Co Ni Cu Zn Ga Ge As Se Br Kr Rb Sr Y Zr Nb Mo Tc Ru Rh Pd Ag Cd In Sn Sb Te I Xe Cs Ba La Ce Pr Nd Pm Sm Eu Gd Tb Dy Ho Er Tm Yb Lu Hf Ta W Re Os Ir Pt Au Hg Tl Pb Bi Po At Rn Fr Ra Ac Th Pa U Np Pu Am Cm Bk Cf Es Fm Md No Lr Rf Db Sg Bh Hs Mt Ds Rg".split

# Print usage if no arguments:
(puts "Usage:  xsdir2xsdata.rb  xsdir_path  [xsdata_path]"; exit) if (xsdir = ARGV.first).nil?

# Check that input file exists:
raise "\nMCNP xsdir file \"%s\" does not exist.\n\n" % xsdir unless File.exists? xsdir

# Open file for writing:
text = IO.read xsdir

# Extract datapath
path = $1 if text =~ /^datapath\s*=(.*)$/i

# Extract XS records
lines = text.split(/directory/i).last.strip.split(/\s*\n\s*/)

result = ''
until lines.empty?
  
  # read multi-line XS record and split parameters
  line = lines.shift; line = $1 + ' ' + lines.shift while line =~ /^(.*)\+\s*$/
  zaid, aw, filename, route, bin, l0, nl, skip, skip, tmp = line.split
  
  # Conversion of atomic weight ratio to atomic weight
  aw = aw.to_f * 1.0086649670000
  
  # Conversion of temperature from MeV to K
  tmp = tmp.to_f * 1.1604518025685E+10
  
  # Split zaid to Z, A and XS key
  z, a, id = $1.to_i, $2.to_i, $3 if zaid =~ /^(\d+)(\d{3})\.(.+)$/

  # type of the data
  type = id[-1].downcase.to_sym
  
  filepath = File.join path, filename
  
  raise "%s: ACE file \"%s\" does not exist.\n" % [zaid, filepath] unless File.exists? filepath
  raise "%s: Data type %d not supported.\n" % [zaid, bin] unless bin.to_i == 1
  
  # Set isomeric state
  if a.zero? and z.zero? then iso = 0
  elsif (a-z)/z.to_f > 4 then iso = 2
  elsif (a-z)/z.to_f > 2 then iso = 1
  else iso = 0 end

  # common part for each alias
  common_part = "%10s  %d %6d %2d %11.6f %10.5f  0  %s\n" % [
    zaid,
    {c:1,y:2,t:3}[type] || -1,
    z*1e3 + a - iso*100,
    iso > 0 ? 1 : 0,
    aw, tmp, filepath
  ]
  
  # standard name
  result += "%11s %s" % [zaid, common_part]
  
  # alias if not thermal data
  unless type == :t
    result += "%11s %s" % [
      "%s-%s%s.%s" % [
        symbols[z],
        a.zero? ? 'nat' : a - iso*100,
        iso > 0 ? 'm' : '',
        id
      ],
      common_part
    ]
  end
end

# Name of file with results
filename = ARGV[1] || (xsdir.gsub(/\.xsdir$/,'') + '.xsdata')

File.open(filename,'w+').write result

puts "Data saved to #{filename}"

#puts result#.scan /^.*95342.*$/
