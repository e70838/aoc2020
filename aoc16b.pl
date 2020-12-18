use strict;
use List::Util 'sum';

my %h;
while (my $line = <>) {
    chomp $line;
    last if $line eq '';
    my ($name, $from1, $to1, $from2, $to2) = $line =~ m/^(.*): (\d+)-(\d+) or (\d+)-(\d+)/;
    die "wrong line $line" unless defined $to2;
    map {$h{$_}->{$name}++} $from1..$to1;
    map {$h{$_}->{$name}++} $from2..$to2;
}

my $line = <>;
die "wrong my ticket $line" unless $line =~ m/your ticket/;

my $line = <>;
chomp $line;
my @my_tickets = split ',', $line;

my $line = <>;
my $line = <>;
my %p;
die "wrong nearby ticket $line" unless $line =~ m/nearby ticket/;
LOOP: while (my $line = <>) {
    chomp $line;
    my @values = split ',', $line;
    foreach my $v (@values) {
        next LOOP unless exists $h{$v};
    }
    foreach my $i (0..$#values) {
        possible ($i, $values[$i]);
    }
}

sub possible {
    my ($i, $v) = @_;
    my %hh = %{$h{$v}};
    if (exists $p{$i}) {
        my @ks = keys %hh;
        foreach my $k (@ks) {
            delete %hh{$k} unless exists %p{$i}->{$k}
        }
    }
    $p{$i} = \%hh; 
}

my $stable;
do {
    $stable = 1;
    foreach my $i (keys %p) {
        my @names = keys %{$p{$i}};
        if (1 == scalar @names) {
            foreach my $j (keys %p) {
                next if $i == $j;
                if (exists $p{$j}->{$names[0]}) {
                    $stable = 0;
                    delete $p{$j}->{$names[0]};
                }
            }
        }
    }
} while (!$stable);

my $mul = 1;
foreach my $i (0..$#my_tickets) {
    my @ks = keys %{$p{$i}};
    print join(', ', $my_tickets[$i], @ks), "\n";
    $mul *= $my_tickets[$i] if $ks[0] =~ m/^departure/;
}

print "$mul\n";
# started at 6h14, part1 finished at 6h33h10, part2 finished at 7:02:16