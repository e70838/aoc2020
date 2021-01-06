use strict;
use List::Util qw( min max );

my $input = '389125467'; # example
#my $input = '156794823'; # real

my @d = split '', $input;
my $s = $#d + 1; # size does not change
my $min = min @d;
my $max = max @d;

for my $move (1..10) {
    print "-- move $move --\n";
    print "cups: ", join ('  ', map {$_ == 0 ? "($d[$_])" : $d[$_]} 0..$#d), "\n";

    my $label = shift @d;
    my $top = $label;
    my @picked = ( shift @d, shift @d, shift @d );
    print "pick up: ", join (', ', @picked), "\n";

    do {
        $label--;
        $label = $max if $label < $min;
        print "destination: $label\n";
    } while ("$label" ~~ @picked);

    foreach my $j (0..$#d) {
        if ($d[$j] == $label) {
            splice @d, $j+1, 0, @picked;
        }
    }
    push @d, $top;
}

print "-- final --\n";
print "cups: ", join ('  ', map {$_ == 0 ? "($d[$_])" : $d[$_]} 0..$#d), "\n";
