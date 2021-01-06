use strict;

my %p; # puzzle pieces
my %images;
my %index;

my $id;
my @lines;
while (my $line = <>) {
    chomp $line;
    if ($line =~ m/\Tile (\d+):/) {
        $id = $1;
    } elsif ($line eq '') {
        add_piece();
    } else {
        push @lines, $line;
    }
}
add_piece();

sub add_piece {
    my $top = $lines[0];
    my $bottom = $lines[$#lines];
    my $left = join ('', map {substr($_, 0, 1)} @lines);
    my $right = join ('', map {substr($_, -1)} @lines);
    my $a = [(scalar reverse $left), $top, $right, (scalar reverse $bottom)]; # clockwise
    $p{$id} = $a;
    #$images{$id} = [map {substr($_, 1, -1)} @lines[1..($#lines-1)]]; # remove borders
    $images{$id} = [@lines]; # leave borders to debug
    add_to_index($id);
    print "$id:\n", join ("\n", @lines), "\n", join (', ', @$a), "\n\n";

    @lines = ();
}

sub add_to_index {
    my $i = shift;
    my $a = $p{$id};
    foreach my $border (@$a) {
        $index{$border}->{$id}=$a;
        $index{scalar reverse $border}->{$id}=$a;
    }
}

sub remove_from_index {
    my $id = shift;
    my $a = $p{$id};
    foreach my $border (@$a) {
        delete $index{$border}->{$id};
        delete $index{$border} unless keys %{$index{$border}};
        my $rb = reverse $border;
        delete $index{$rb}->{$id};
        delete $index{$rb} unless keys %{$index{$rb}};
    }
    # print "$id removed from index\n";
}

my ($min_x, $max_x, $min_y, $max_y) = (0, 0, 0, 0);

#my ($start, $s_sides) = (1171, $p{1171}); # = (%p);
#my ($start, $s_sides) = (1951, $p{1951}); # = (%p);
my ($start, $s_sides) = (%p);
my %all_pieces;
my %bs; # boundaries
my %bi; # index by coordinates;
merge_piece($start, 0, 0, @$s_sides);

my $h = $#{$images{$bi{"0 0"}}};

sub rotate_p {
    my $e = shift; # rotate image counter clockwise
    print "rotate $e\n";
    my @l = @{$images{$e}};
    #print "before:\n  ", join ("\n  ", @l), "\n";
    my @r;
    foreach my $i (0..$#l) {
        push @r, join ('', map {substr($_, $i, 1)} @l);
    }
    #print "after:\n  ", join ("\n  ", reverse @r), "\n";
    $images{$e} = [reverse @r];
}
sub flip_v {
    my $e = shift; # flip image
    print "flip_v $e\n";
    $images{$e} = [reverse @{$images{$e}}];
}
sub flip_h {
    my $e = shift; # flip image
    print "flip_h $e\n";
    $images{$e} = [map {scalar reverse $_} @{$images{$e}}];
}

LOOP: while (%p) {
    print_puzzle();
    foreach my $k (keys %bs) {
        delete $bs{$k} unless exists $index{$k};
    }
    my %weight;
    foreach my $k (keys %bs) {
        my ($x, $y) = @{$bs{$k}};
        $weight{}
    }
    my @kbs = sort keys %bs;
    print "keys ", join ("\n     ", map {"$_ @{$bs{$_}}"} @kbs), "\n";
    # $bs{$i} = [$x, $y, $d];

    foreach my $edge (@kbs) {
        if ($edge eq reverse $edge) {
            print "symetric edge $edge \n";
            next;
        }
        my $h = $index{$edge};
        if (2 < scalar %$h) {
            die "ambigous \n";
            next;
        }

        my ($x, $y, $d) = @{$bs{$edge}};
        my ($e, $es) = %$h;
        print "considering edge $edge on $d for $x:$y\n--> found $e @$es\n";

        my @n = @$es; # sides of the piece
        while (($n[$d] ne $edge) and ($n[$d] ne reverse $edge)) {
            rotate_p($e);#rotate_p($e);rotate_p($e);
            push @n, (shift @n); # rotate right
            #unshift @n, (pop @n); # rotate left
            print "", join ("\n", @{$images{$e}}), "\n", join (', ', @n), "\n";
        }
        if ($n[$d] eq $edge) { # flip is needed
            if ($d % 2) {
                flip_h($e);
                @n = map {scalar reverse $_} ($n[2], $n[1], $n[0], $n[3]);
            } else {
                flip_v($e);
                @n = map {scalar reverse $_} ($n[0], $n[3], $n[1], $n[2]);
            }
            #rotate_p($e);rotate_p($e);
            print "", join ("\n", @{$images{$e}}), "\n", join (', ', @n), "\n";
        }
        merge_piece($e, $x, $y, @n);
        delete $bs{$edge}; # do not consider anymore this edge
        next LOOP;
    }
}

print_puzzle();

sub print_puzzle {
    print "puzzle\n";
    print "\t", join ("\t", ($min_x..$max_x)), "\n";
    foreach my $y (reverse ($min_y..$max_y)) {
        print "$y :";
        foreach my $x ($min_x..$max_x) {
            print "\t", $bi{"$x $y"};
        }
        print "\n";
    }
    foreach my $y (reverse ($min_y..$max_y)) {
        foreach my $i (0..$h) {
            foreach my $x ($min_x..$max_x) {
                print "  ", (exists $bi{"$x $y"}) ? $images{$bi{"$x $y"}}->[$i] : (' ' x length($images{$bi{"0 0"}}->[$i]));
            }
            print "\n";
        }
        print "\n";
    }
    print "end puzzle\n";
}

my @big_map;
foreach my $y (reverse($min_y..$max_y)) {
    foreach my $i (0..$h) {
        push @big_map, join('', map {$images{$bi{"$_ $y"}}->[$i]} $min_x..$max_x);
    }
}

# orient the map like the example
my @r;
foreach my $i (0..$#big_map) {
    push @r, join ('', reverse map {substr($_, $i, 1)} @big_map);
}
@big_map = reverse @r;

foreach my $l (@big_map) {
    print "", $l, "\n";
}

my @monster = (
"                  #  ",
"#    ##    ##    ### ",
" #  #  #  #  #  #    ");

my $count = 0;

sub search_monster_at_top {
    my ($y, @m) = @_; # map
    foreach my $dx (0 .. (length($m[0]) - length($monster[0]) )) {
        my $found = 1;
        foreach my $y (0..$#monster) {
            foreach my $x (0..(length($monster[$y])-1)) {
                $found = 0 if (substr($monster[$y], $x, 1) eq '#')
                        and (substr($m[$y], $x+$dx, 1) ne '#');
            }
        }
        if ($found) {
            print "found at $dx $y\n";
            $count++;
        }
    }
}

sub search_monster {
    my @m = @_; # map
    my $y = 1;
    while ((scalar @m) >= (scalar @monster)) {
        search_monster_at_top ($y, @m);
        shift @m;
        $y++;
    }
}

search_monster(@big_map);
search_monster(map {scalar reverse $_} @big_map);
search_monster(reverse @big_map);
search_monster(map {scalar reverse $_} reverse @big_map);

@r = ();
foreach my $i (0..$#big_map) {
    push @r, join ('', map {substr($_, $i, 1)} @big_map);
}
search_monster(@r);
search_monster(map {scalar reverse $_} @r);
search_monster(reverse @r);
search_monster(map {scalar reverse $_} reverse @r);

print "$count\n";
# 174 too low

my $all = join ('', @big_map);
my $nb_hash = 0;
$all =~ s/#/$nb_h
ash++/eg;

$all = join ('', @monster);
my $nb_hash_in_monster = 0;
$all =~ s/#/$nb_hash_in_monster++/eg;

print "$count $nb_hash $nb_hash_in_monster\n";

sub merge_piece {
    my ($id, $x, $y, @sides) = @_;
    print "merging piece $id, $x, $y, @sides\n";
    $all_pieces{$id} = \@sides;
    add_boundary($sides[0], $x-1, $y, 2);
    add_boundary($sides[1], $x, $y+1, 3);
    add_boundary($sides[2], $x+1, $y, 0);
    add_boundary($sides[3], $x, $y-1, 1);
    remove_from_index($id); delete $p{$id};
    $min_x = $x if $x < $min_x;
    $max_x = $x if $x > $max_x;
    $min_y = $y if $y < $min_y;
    $max_y = $y if $y > $max_y;
    $bi{"$x $y"} = $id;
}
sub add_boundary {
    my ($i, $x, $y, $d) = @_;
    $bs{$i} = [$x, $y, $d];
}

