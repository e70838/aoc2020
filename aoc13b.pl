use strict;

my $start = <>; # skip first line
my $all_bus = <>;
chomp $all_bus;
my @bus = split (',', $all_bus);

# https://rosettacode.org/wiki/Least_common_multiple#Perl
sub gcd {
	my ($x, $y) = @_;
	while ($x) { ($x, $y) = ($y % $x, $x) }
	$y
}
 
sub lcm {
	my ($x, $y) = @_;
	($x && $y) and $x / gcd($x, $y) * $y or 0;
}

$start = $bus [0];
my $freq = $bus [0];

foreach my $k (1..$#bus) {
    next if $bus[$k] eq 'x';
    my $fb = $bus[$k];
    while (($start+$k) % $fb) {
        $start += $freq;
    }
    $freq = &lcm($freq, $fb);
}

print "$start\n";
# part b finished at 8:33 (submitted 8:38:42) (the slow version was working at 8:15),
# part a finished at 8:06 (submitted 08:06:55), started at 7:54 (logged in at 7:53)