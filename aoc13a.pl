use strict;

my $start = <>;
my $all_bus = <>;
chomp $all_bus;
my @bus = grep { $_ ne 'x'} split (',', $all_bus);

my $i = $start;
while (1) {
    foreach my $b (@bus) {
        if ($i % $b == 0) {
            my $p = ($i - $start) * $b;
            die "$i $b $p\n";
        }
    }
    $i ++;
}