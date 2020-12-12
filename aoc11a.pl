use strict;

my @m;
my $width;
my $max;

foreach my $line (<>) {
    chomp $line;
    $width = 1 + length $line;
    push @m, split ('', $line . '.');
}
my $max = $#m -1;
map {push @m, '.'} 0 .. $width;

my @directions = (-$width-1, -$width, -$width+1, -1, 1, $width-1, $width, $width+1);


sub nb {
    my ($pos, $m) = @_;
    my $r = 0;
    foreach my $d (@directions) {
        next if $pos+$d < 0;
        $r++ if $m[$pos+$d] eq '#';
    }
    return $r;
}

sub evolve {
    my $m = shift;
    my @r = @$m;
    foreach my $i (0..$max) {
        if ($m[$i] eq 'L') {
            $r[$i] = '#' if nb($i, $m) == 0;
        } elsif ($m[$i] eq '#') {
            $r[$i] = 'L' if nb($i, $m) >= 4;
        }
    }
    return @r;
}

my $prev = join('', @m);
while (1) {
    @m = evolve(\@m);
    my $next = join('', @m);
    if ($next eq $prev) {
        my $count = () = $prev =~ m/\Q#/g;
        die "end $count";
    }
    $prev = $next;
}