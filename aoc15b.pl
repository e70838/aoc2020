use strict;
use List::Util 'sum';

#my @nums = (0,3,6);
my @nums = (15,5,1,4,7,0);

my %h = map { ($nums[$_] => $_)} 0..$#nums-1;

my $limit = 30000000;
while ($#nums < $limit) {
    my $last = $nums[$#nums];
    my $next = 0;    
    if (exists $h{$last}) {
        my $i = $h{$last};
        $next = $#nums - $i;
    }
    print "", $#nums+2, " $last --> $next\n" if $#nums + 2 == $limit;
    $h{$last} = $#nums;
    push @nums, $next;
}
# 175594