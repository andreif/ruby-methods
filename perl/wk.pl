#!/usr/bin/perl
# Andrei Fokau, February 20, 2008

if ($ARGV[0] =~ /a|all/i) { # all nodes
	@NODE = 0 .. 7;
} else {
	@NODE = @ARGV;
}

for ($i = 0; $i <= $#NODE; $i++) {
	system "ssh node000$NODE[$i] killall orted\n";
	system "ssh node000$NODE[$i] killall orted\n";
}
