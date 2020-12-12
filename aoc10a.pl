use strict;

my @a = <>;
chomp @a;
@a = sort {$a <=> $b} @a;
my %deltas = (3 => 1);
my $start = 0;
foreach my $d (@a) {
    $deltas{$d-$start}++;
    $start = $d;
}

foreach my $k (sort keys %deltas) {
    print "$k -> $deltas{$k}\n";
}

print $deltas{1} * $deltas{3}, "\n";