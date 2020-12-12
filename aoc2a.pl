

my $total = 0;

foreach my $line (<>) {
    chomp $line;
    my ($lowest, $highest, $letter, $password) = $line =~ m/^(\d+)-(\d+)\s+(.):\s+(.*)/;
    print "$lowest, $highest, $letter, $password\n";
    my $count =()= $password =~ m/$letter/g; #goatse operator
    print " --> $count\n";
    $total++ if $count >= $lowest and $count <= $highest;
}
print "$total\n";
