use strict;

my @a = map {chomp; $_} <>;
print join (', ', @a), "\n";
my $w = 25; # size of preamble

my $i = $w;
MAIN : while ($i < @a) {
    my %h = map { ($_ => 1) } @a[($i-$w)..($i-1)];

    foreach my $k (keys %h) {
        if (exists $h{$a[$i]-$k}) {
            $i++;
            next MAIN;
        }
    }
    print "not a sum $a[$i] : ", join (', ', @a[($i-$w)..($i-1)]), "\n";
    $i++;
}

