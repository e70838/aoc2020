use strict;
use Math::Trig;

my $lat = 0;
my $long = 0;
my $heading = 90; # face east

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
        $heading -= $v;
    } elsif ($a eq 'R') {
        $heading += $v;
    } elsif ($a eq 'F') {
        $long += $v * sin($heading * pi() / 180);
        $lat += $v * cos($heading * pi() / 180);
    } else {
        warn "error $line\n";
    }
    print "$line  $long $lat $heading\n";
}

print "$lat $long \n";