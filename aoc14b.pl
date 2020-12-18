use strict;
use List::Util 'sum';

my %mem;
my @mask;
my @addresses = (0);
while (my $line = <>) {
    chomp $line;
    if ($line =~ m/mask = (.*)/) {
        @mask = reverse (split('', $1));
        @addresses = (0);
        foreach my $i (0..$#mask) {
            if ($mask[$i] eq 'X') {
                push @addresses, map {$_ + 2 ** $i} @addresses;
            } 
        }

    } elsif ($line =~ m/mem\[(\d+)\] = (\d+)/) {
        my $addr = $1;
        my $v = $2;     
        foreach my $i (0..$#mask) {
            if ($mask[$i] eq 'X') {
                $addr &= ~ (2 ** $i);
            } elsif ($mask[$i] eq '1') {
                $addr |= 2 ** $i;
            }
        }
        map {$mem{$addr+$_} = $v; } @addresses;
        print "$1 $addr $v @mask\n";
    } else {
        die "error $line";
    }
}

print "", (sum values %mem), "\n";
# 19345966243