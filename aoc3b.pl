

my @trees;
foreach my $line (<>) {
    chomp $line;
    my @row = split ('', $line);
    push @trees, \@row;
}

sub is_tree {
    my ($x, $y) = @_;
    my $row = $trees[$y];
    return $row->[$x % (scalar @$row)] eq '#';
}

sub count_tree {
    my ($dx, $dy) = @_;
    my $x = 0;
    my $y = 0;
    my $nb_trees = 0;
    while ($y <= $#trees) {
        $nb_trees++ if is_tree($x, $y);
        $x += $dx;
        $y += $dy
    }
    return $nb_trees;
}
print count_tree(1, 1)
    * count_tree(3, 1)
    * count_tree(5, 1)
    * count_tree(7, 1)
    * count_tree(1, 2)
 . "\n";

