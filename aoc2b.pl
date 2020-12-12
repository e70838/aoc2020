

my $total = 0;

foreach my $line (<>) {
    chomp $line;
    my ($lowest, $highest, $letter, $password) = $line =~ m/^(\d+)-(\d+)\s+(.):\s+(.*)/;
    my @chars = split('', " $password");
    $total++ if ($letter eq $chars[$lowest] or $letter eq $chars[$highest]) and $chars[$lowest] ne $chars[$highest];
}
print "$total\n";
# 664 too high
