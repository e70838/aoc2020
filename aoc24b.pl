use strict;

my %d;

while (my $line = <>) {
    my ($x, $y) = (0, 0);
    chomp $line;
    #print "processing $line\n";
    $line =~ s/(e|se|sw|w|nw|ne)/
      if ($1 eq 'e') {
        $x -= 2;
      } elsif ($1 eq 'w') {
        $x += 2;
      } elsif ($1 eq 'se') {
        $x--; $y--;
      } elsif ($1 eq 'sw') {
        $x++; $y--;
      } elsif ($1 eq 'nw') {
        $x++; $y++;
      } elsif ($1 eq 'ne') {
        $x--; $y++;
      } else {
        die "error $1 at $line";
      }
      ''/eg;
    my $dest = "$x#$y";
    $d{$dest} = 1 - $d{$dest}; # 1 is black, 0 is white
}
my $sum = 0;
foreach my $c (values %d) {
    $sum += $c;
}
my $day = 1;
print "Day $day nb black: $sum\n";

while ($day <= 100) {
    next_day();
    $sum = 0;
    foreach my $c (values %d) {
        $sum += $c;
    }
    print "Day $day nb black: $sum\n";
    $day++;
}

sub next_day {
    my %black_neighbours; # nb of black neighbours
    foreach my $k (keys %d) {
        next unless $d{$k}; # skip white
        my ($x, $y) = $k =~ m/(.*)#(.*)/;
        foreach my $delta (([-2, 0], [2, 0], [-1, -1], [-1, 1], [1, 1], [1, -1])) {
            my $xx = $x + $delta->[0];
            my $yy = $y + $delta->[1];
            $black_neighbours{"$xx#$yy"}++;
        }
    }
    my %next_d;
    # keep black tiles adjacent to 1 or 2 black tiles
    foreach my $k (keys %d) {
        next unless $d{$k}; # skip white
        if ($black_neighbours{$k} == 1 or $black_neighbours{$k} == 2) {
            $next_d{$k} = 1;
        }
    }
    # return white tiles adjacent to 2 black
    foreach my $k (keys %black_neighbours) {
        next if $black_neighbours{$k} != 2;
        next if exists $d{$k} and $d{$k} != 0;
        $next_d{$k} = 1;
    }
    %d = %next_d;
}

