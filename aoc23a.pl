use strict;
use List::Util qw( min max );

#my $input = '389125467'; # example
my $input = '156794823'; # real

my $i = 0;
my @d = split '', $input;
my $s = $#d + 1; # size does not change
my $min = min @d;
my $max = max @d;

for my $move (1..100) {
    print "-- move $move --\n";
    print "cups: ", join ('  ', map {$_ == $i ? "($d[$_])" : $d[$_]} 0..$#d), "\n";

    my @picked;
    map {
        if ($i < $#d) {
            push @picked, splice @d, $i+1, 1;
        } else {
            push @picked, splice @d, 0, 1;
            $i--;
        }
    } 1..3; # repeat three times
    print "pick up: ", join (', ', @picked), "\n";

    my $label = $d[$i];
    do {
        $label--;
        $label = $max if $label < $min;
        print "destination: $label\n";
    } while ("$label" ~~ @picked);

    foreach my $j (0..$#d) {
        if ($d[$j] == $label) {
            splice @d, $j+1, 0, @picked;
            if ($j < $i) {
                my @left = splice @d, 0, 3;
                push @d, @left;
            }
        }
    }

    $i++;
    $i = 0 if $i >= $s;
}

print "-- final --\n";
print "cups: ", join ('  ', map {$_ == $i ? "($d[$_])" : $d[$_]} 0..$#d), "\n";
