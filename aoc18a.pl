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
    return calcu ($line) if $line =~ s/(\d+) (\+|\*) (\d+)/($2 eq '+') ? ($1 + $3):($1 * $3)/e;
    #return calcu ($line) if $line =~ s/(\d+) \+ (\d+)/$1 + $2/e;
    #return calcu ($line) if $line =~ s/(\d+) \* (\d+)/$1 * $2/e;
    $d--;
    return $line;
}