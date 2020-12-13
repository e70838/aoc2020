use strict;

my $start = <>;
my $all_bus = <>;
chomp $all_bus;
my @bus = split (',', $all_bus);

my $i = -1;
MAIN: while (1) {
    $i ++;
    foreach my $bi (0 .. $#bus) {
        if ($bus[$bi] eq 'x') {
            # no constraint
        } elsif (($i + $bi) % $bus[$bi] != 0) {
            next MAIN;
        }
    }
    die "$i\n";
}
