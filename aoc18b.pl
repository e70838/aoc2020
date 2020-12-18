use strict;

my $d = 0;
my $sum;
while (my $line = <>) {
    chomp $line;
    do {
        print "reducing $line\n";
    } while ($line =~ s/\(([^\(\)]+)\)/calcu($1)/e);
    $sum += calcu($line);
    print "--> $sum\n";
}
print "sum $sum\n";

sub calcu {
    my $line = shift;
    print "", (' ' x $d) , "calcu $line\n"; $d++;
    #return calcu ($line) if $line =~ s/(\d+) (\+|\*) (\d+)/($2 eq '+') ? ($1 + $3):($1 * $3)/e;
    return calcu ($line) if $line =~ s/(\d+) \+ (\d+)/$1 + $2/e;
    return calcu ($line) if $line =~ s/(\d+) \* (\d+)/$1 * $2/e;
    $d--;
    return $line;
}
# started at 6h54 part1 submitted at 7:33:06, part2 submitted at 07:36:00 (finished at 07:33:40) 