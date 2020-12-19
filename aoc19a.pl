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