
my %h = map { chomp ; ($_ => 1) } <>;

my $r = 1;
foreach my $k (keys %h) {
    $r *= $k if exists $h{2020-$k};
}
print "$r\n";
