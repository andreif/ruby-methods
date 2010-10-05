#!/usr/bin/perl
print "XSDIR viewer script  |  Andrei Fokau,  September 15, 2008\n";

#xs xsdir 92
#xs 92235
#xs xsdir p
#xs * 235 pte
#full: xs xsdir 92/U/U235/92235/*235 pgec
#if no args then exex "more xsdir"

# 1) $a=$ARGV 2) if $a[0] filename then $xsdir=$a[0] or $xsdir = 'xsdir' and $a = $a[1:end] 3) 

if ($#ARGV < 0) {
	system "more xsdir";
	
#} elsif ($ARGV[0] =~ /*?\d+/) {
	
} else {
	$xsdir = 'xsdir';
	system "grep --regexp='^ $ARGV[0]\.$ARGV[1]' $xsdir";
}

