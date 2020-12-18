use strict;

my %h;

my $y = 0;
my $xm;
while (my $line = <>) {
    chomp $line;
    my @cols = split '', $line;
    $xm = $#cols;
    foreach my $x (0..$#cols) {
        $h{"$x#$y#0#0"} ++ if $cols[$x] eq '#';
    }
    $y++;
}
print join (', ', keys %h), "\n";
my $ym = $y -1;

my @n;
for my $dx ((0, -1, 1)) {
    for my $dy ((0, -1, 1)) {
        for my $dz ((0, -1, 1)) {
            for my $dw ((0, -1, 1)) {
                push @n, [$dx, $dy, $dz, $dw];
            }
        }
    }
}
shift @n; # remove 0, 0, 0, 0

foreach my $gen (1..6) {
    my %h2 = (); # future h
    foreach my $w ((0-$gen) .. (0+$gen)) {
    foreach my $z ((0-$gen) .. (0+$gen)) {
        print "\nz=$z, w=$w\n";
        foreach my $y ((0-$gen) .. ($ym+$gen)) {
            foreach my $x ((0-$gen) .. ($xm+$gen)) {
                my $nb = 0;
                foreach my $d (@n) {
                    my $dest = ($x+$d->[0]) . '#' . ($y+$d->[1]) . '#' . ($z+$d->[2]) . '#' . ($w+$d->[3]);
                    #print "$x $y $z $dest\n";
                    $nb ++ if exists $h{$dest};
                }
                #print "$gen $nb -> $x#$y#$z\n";  
                if (exists $h{"$x#$y#$z#$w"}) {
                    if (($nb == 2) or ($nb == 3)) {
                        $h2{"$x#$y#$z#$w"}++;
                        #print "$gen true $nb -> $x#$y#$z\n";  
                    };
                } else {
                    if ($nb == 3) {
                        $h2{"$x#$y#$z#$w"}++;
                        #print "$gen false $nb -> $x#$y#$z\n";  
                    };
                }
                print (exists $h2{"$x#$y#$z#$w"} ? '#' : '.');
            }
            print "\n";
        }
    }
    }
    %h = %h2;
    print "", (scalar keys %h2), "\n";

}

print "", (scalar keys %h), "\n";
# started at 07:10 (no electricity)
# part 1 #8:04:49
# part 2 #8:30:49