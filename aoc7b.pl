use strict;

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

print "convert to DAG\n";
my @dag;
while (scalar @dag < scalar keys %h) {
    foreach my $k (keys %h) {
        next if $k ~~ @dag;
        my @kcs = keys %{$h{$k}};
        my $all_is_known = 1;
        foreach my $kc (@kcs) {
            $all_is_known = 0 unless $kc ~~ @dag;
        }
        push @dag, $k if $all_is_known;
    }
}
print "converted\n";

my %r;

foreach my $k (@dag) {
    $r{$k} = 0;
    #print "$k  -> \n";
    foreach my $kc (keys %{$h{$k}}) {
        $r{$k} += (1 + $r{$kc}) * $h{$k}->{$kc};
        #print "  $kc -> $h{$k}->{$kc} * $r{$kc} --> $r{$k}\n";
    }
}

print $r{'shiny gold'}, "\n";
