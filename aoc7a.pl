use strict;

my $searched_color = 'shiny gold';

my %h;
foreach my $line (<>) {
    chomp $line;
    my ($container, $contents) = $line =~ m/^(.*) bags contain (.*)\.$/;
    die "wrong line $line" unless defined $contents;
    my %c;
    if ($contents ne 'no other bags') {
        foreach my $content (split ', ', $contents) {
            my ($nb, $color) = $content =~ m/^(\d+) (.*) bag/;
            die "wrong color $content in $line" unless defined $color;
            $c{$color} = $nb;
        }
    }
    $h{$container} = \%c;
}

my %r; # hash that contains true for colors that can contain gold, false for other

sub all_is_known {
    foreach my $k (keys %h) {
        return 0 unless exists $r{$k};
    }
    return 1;
}

while (!all_is_known()) {
    OUTER: foreach my $k (keys %h) {
        next if exists $r{$k};
        my @kcs = keys %{$h{$k}};
        my $all_is_known = 1;
        foreach my $kc (@kcs) {
            if ($kc eq $searched_color or (exists $r{$kc} and $r{$kc})) {
                $r{$k} = 1;
                next OUTER;
            }
            $r{$kc} = 0 unless exists $h{$kc};
            $all_is_known = 0 unless exists $r{$kc};
        }
        $r{$k} = 0 if $all_is_known and not exists $r{$k};
    }
}

my $count = 0;
foreach my $k (keys %r) {
    $count++ if $r{$k};
}

print "sum -> $count\n";
