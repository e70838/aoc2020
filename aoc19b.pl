use strict;

my %rt; # rules in text
while (my $line = <>) {
    chomp $line;
    last if $line eq '';
    my ($n, $t) = $line =~ m/^(\d+): (.*)$/;
    die "wrong line $line" unless defined $t;
    $rt{$n+0} = $t;
}

sub build {
    my $s = shift;
    if ($s =~ m/"(.*)"/) {
        return "[$1]";
    } elsif ($s =~ m/(.*) \| (.*)/) {
        my $l = $1;
        my $r = $2;
        return '(' . build($l) . '|' . build($r) . ')';
    } elsif ($s =~ m/^[ 0-9]+$/) {
        my @nums = split (' ', $s);
        if ($#nums) {
            return '(' . join ('', map {build($_)} @nums) . ')';
        } elsif ($nums[0] == 8) {
            return '(' . build(42) . '+)';
        } elsif ($nums[0] == 11) {
            return '(?<NAME>' . build(42) . '(|(?&NAME))' . build(31) . ')';
        } else {
            return build($rt{$nums[0]});
        }
    } else {
        die "error $s";
    }
}

#1 [a]
#3 [b]
#2 ([a][b])|([b][a])

#my $pattern = '[a](([a][b])|([b][a]))';
my $pattern = build($rt{'0'});

#my $pattern = '(?<NAME>42(|(?&NAME))31)';

my $count = 0;

while (my $line = <>) {
    chomp $line;
    if ($line =~ qr/^$pattern$/) {
        print "$line match\n";
        $count++;
    } else {
        print "$line dont match\n";
    }
}
print "$count\n";
# logged in at 6:47
# part1 submitted at 07:21:23
# part2 submitted at 07:42:33