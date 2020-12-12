use strict;

my @a = <>;
chomp @a;
@a = sort {$a <=> $b} @a;

sub count {
    my ($h, $n, @s) = @_;
    return 1 unless scalar @s;
    # can we skip $n
    if ($s[0] - $h <= 3) {
        return count($h, @s) + count($n, @s);
    } else {
        return count($n, @s);
    }
}

# when there is a gap of 3, slice before and slice after can be count independently
# and the counts can be multiplied.
my @m;
my @wip = (0);
foreach my $i (0..$#a) {
    if ($a[$i]-$wip[$#wip] == 3) {
        push @m, count(@wip);
        @wip = ();
    }
    push @wip, $a[$i];
}
push @m, count(@wip);

my $r = 1;
foreach my $v (@m) {
    $r *= $v;
}
print $r, "\n";

print count (0, @a), "\n";
