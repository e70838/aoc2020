use strict;
use Math::Trig;

# pos of the waypoint
my $lat = 1;
my $long = 10;

 # pos of the ship
my $slat = 0;
my $slong = 0;

my $heading = 90; # face east

sub rotate {
    my $t = (shift) * pi()/180.0;
    ($lat, $long) = ($lat * cos($t) + $long * sin($t), -$lat * sin($t) + $long * cos($t));
}

foreach my $line (<>) {
    chomp $line;
    my ($a, $v) = $line =~ m/(.)(\d+)/;
    if ($a eq 'N') {
        $lat += $v;
    } elsif ($a eq 'S') {
        $lat -= $v;
    } elsif ($a eq 'E') {
        $long += $v;
    } elsif ($a eq 'W') {
        $long -= $v;
    } elsif ($a eq 'L') {
        rotate($v);
    } elsif ($a eq 'R') {
        rotate(-$v);
    } elsif ($a eq 'F') {
        $slong += $v * $long;
        $slat  += $v * $lat;
    } else {
        warn "error $line\n";
    }
    print "$line wpt: $long $lat, ship: $slong $slat  $heading\n";
}

print "$slat $slong \n";
print abs($slat)+abs($slong), "\n";
# part b finished at 6:32 (submitted 6:33:29), part a finished at 6:14, started at 6:00