use strict;

my @a = map {chomp; $_} <>;
print join (', ', @a), "\n";
my $w = 25; # size of preamble

my $i = $w;
MAIN : while ($i < @a) {
    my %h = map { ($_ => 1) } @a[($i-$w)..($i-1)];

    foreach my $k (keys %h) {
        if (exists $h{$a[$i]-$k}) {
            $i++;
            next MAIN;
        }
    }
    print "not a sum $a[$i] : ", join (', ', @a[($i-$w)..($i-1)]), "\n";
    foreach my $start (0..$#a) {
        my $sum = $a[$start];
        my $end = $start + 1;
        do {
            $sum += $a[$end];
            $end++;
        } while (($sum < $a[$i]) && ($end < scalar @a));
        if ($sum == $a[$i]) {
            my @the_range = sort {$a <=> $b} (@a[$start .. ($end -1)]);
            print "$sum =", join (' + ', @a[$start .. ($end -1)]), "\n";
            print "  --> $the_range[0] + $the_range[$#the_range] = ",
            $the_range[0] + $the_range[$#the_range], "\n";
        }
    }
    die "";
}

# 1994105
# part b finished at 6:32 (submitted 06:32:17),
# part a finished at 6:16 (submitted 06:16:30), started at 6:00