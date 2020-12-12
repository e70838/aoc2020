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

my %r; # hash that contains true for colors that can contain gold, false for other

OUTER: foreach my $k (@dag) {
     my @kcs = keys %{$h{$k}};
     foreach my $kc (@kcs) {
         if ($kc eq $searched_color or (exists $r{$kc} and $r{$kc})) {
             $r{$k} = 1;
             next OUTER;
         }
         $r{$kc} = 0 unless exists $h{$kc};
     }
     $r{$k} = 0;
}

my $count = 0;
foreach my $k (keys %r) {
    $count++ if $r{$k};
}

print "sum -> $count\n";
