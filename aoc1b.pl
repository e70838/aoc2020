
my %h = map { chomp ; ($_ => 1) } <>;

sub find_two_with_sum {
    my ($sum, $first) = @_;    
    my $r = 1;
    foreach my $k (keys %h) {
        $r *= $k if $k != $first and exists $h{$sum-$k};
    }
    return $r;
}

foreach my $k (keys %h) {
    my $r = find_two_with_sum(2020-$k, $k);
    print "$k $r " . ($k * $r) . "\n" if $r != 1;
}
