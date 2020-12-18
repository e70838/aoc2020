use strict;
use List::Util 'sum';

#my @nums = (0,3,6);
my @nums = (15,5,1,4,7,0);

while ($#nums < 2020) {
    my $last = $nums[$#nums];
    my $i = $#nums - 1;
    while ($i >= 0 && $nums[$i] != $last) {
        $i--;
    }
    my $next = 0;
    if ($i >= 0) {
        $next = $#nums - $i;
    }
    print "", $#nums+2, " $last --> $next\n";
    push @nums, $next;
}
