use strict;
use List::Util qw( min max );

my $input = '389125467'; # example
#my $input = '156794823'; # real

my @d = split '', $input;
push @d, 10..1000000;
my $s = $#d + 1; # size does not change
my $min = min @d;
my $max = max @d;
print "start\n";
for my $move (1..500) {
    my $label = shift @d;
    my $top = $label;
    my @picked = ( shift @d, shift @d, shift @d );

    do {
        $label--;
        $label = $max if $label < $min;
    } while ("$label" ~~ @picked);

    foreach my $j (0..$#d) {
        if ($d[$j] == $label) {
            splice @d, $j+1, 0, @picked;
        }
    }
    push @d, $top;
}

print "-- final --\n";
print "cups: ", join ('  ', map {$_ == 0 ? "($d[$_])" : $d[$_]} 0..20), "\n";

my $label = shift @d;
my @picked = ( shift @d, shift @d );
my $prod = $picked[0] * $picked[1];
print "pick up: @picked $prod\n";

