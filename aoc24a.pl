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
print "nb black: $sum\n";
