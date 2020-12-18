use strict;

my %h;

my $y = 0;
my $xm;
while (my $line = <>) {
    chomp $line;
    my @cols = split '', $line;
    $xm = $#cols;
    foreach my $x (0..$#cols) {
        $h{"$x#$y#0"} ++ if $cols[$x] eq '#';
    }
    $y++;
}
print join (', ', keys %h), "\n";
my $ym = $y -1;

my @n;
for my $dx ((0, -1, 1)) {
    for my $dy ((0, -1, 1)) {
        for my $dz ((0, -1, 1)) {
            push @n, [$dx, $dy, $dz];
        }
    }
}
shift @n; # remove 0, 0, 0

foreach my $gen (1..1) {
    my %h2 = (); # future h
    foreach my $z ((0-$gen) .. (0+$gen)) {
        print "\nz=$z\n";
        foreach my $y ((0-$gen) .. ($ym+$gen)) {
            foreach my $x ((0-$gen) .. ($xm+$gen)) {
                my $nb = 0;
                foreach my $d (@n) {
                    my $dest = ($x+$d->[0]) . '#' . ($y+$d->[1]) . '#' . ($z+$d->[2]);
                    #print "$x $y $z $dest\n";
                    $nb ++ if exists $h{$dest};
                }
                #print "$gen $nb -> $x#$y#$z\n";  
                if (exists $h{"$x#$y#$z"}) {
                    if ($nb == 2 or $nb == 3) {
                        $h2{"$x#$y#$z"}++;
                        #print "$gen true $nb -> $x#$y#$z\n";  
                    };
                } else {
                    if ($nb == 3) {
                        $h2{"$x#$y#$z"}++;
                        #print "$gen false $nb -> $x#$y#$z\n";  
                    };
                }
                print (exists $h2{"$x#$y#$z"} ? '#' : '.');
            }
            print "\n";
        }
    }
    %h = %h2;
    print "", (scalar keys %h2), "\n";
}

print "", (scalar keys %h), "\n";