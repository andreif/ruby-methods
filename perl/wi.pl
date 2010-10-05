#!/usr/bin/perl
print "WareWulf information script  |  Andrei Fokau,  March 26, 2008\n";

if ($ARGV[0]) {
	
	if ($ARGV[0] eq "m") {
		system "ps au -u andrei";
		print "------------------------------------------------------------------------\n";
		system "df -h";
		print "------------------------------------------------------------------------\n";
		system "ls";
		system "ls -la xsdir*";
		system "ls -la rssa*";
		exit;
	}
	
	@NODE = @ARGV;
} else {
	@NODE = 0 .. 21;
}

print "\n\n\n";
for ($i = 0; $i <= $#NODE; $i++) {
	$nd = sprintf("node%04d", $NODE[$i]);
	my_header($nd);
	system "ssh $nd ps auxr";
}
my_header("Master");
system "ps auxr";
print "\n\n\n";


sub my_header {
	my($name) = @_;
	print "\n========================================================================\n";
	print " $name\n";
	print "------------------------------------------------------------------------\n";
}
