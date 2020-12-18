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
my $error_rate;
die "wrong nearby ticket $line" unless $line =~ m/nearby ticket/;
while (my $line = <>) {
    chomp $line;
    my @values = split ',', $line;
    foreach my $v (@values) {
        $error_rate += $v unless exists $h{$v};
    }
}
print "$error_rate\n"
