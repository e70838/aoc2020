use strict;
use List::Util 'sum';

my %mem;
my @mask;
while (my $line = <>) {
    chomp $line;
    if ($line =~ m/mask = (.*)/) {
        @mask = reverse (split('', $1));

    } elsif ($line =~ m/mem\[(\d+)\] = (\d+)/) {
        my $addr = $1;
        my $v = $2;     
        foreach my $i (0..$#mask) {
            if ($mask[$i] eq '0') {
                $v &= ~ (2 ** $i);
            } elsif ($mask[$i] eq '1') {
                $v |= 2 ** $i;
            }
        }   
        $mem{$addr} = $v;
        print "$addr $2 $v @mask\n";
    } else {
        die "error $line";
    }
}

print sum values %mem;
# 19345966243