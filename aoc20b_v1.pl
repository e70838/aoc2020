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
    my $a = [$top, $right, (scalar reverse $bottom), (scalar reverse $left)]; # clockwise
    $p{$id} = $a;
    $images{$id} = [map {substr($_, 1, -1)} @lines[1..($#lines-1)]]; # remove borders
    add_to_index($id);
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
my ($start, $s_sides) = (1951, $p{1951}); # = (%p);
my %all_pieces;
my %bs; # boundaries
my %bi; # index by coordinates;
merge_piece($start, 0, 0, @$s_sides);

sub rotate_p {
    my $e = shift; # rotate image
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
    $images{$e} = [map {reverse $_} @{$images{$e}}];
}

LOOP: while (%p) {
    foreach my $edge (keys %bs) {
        next unless exists $index{$edge};
        if ($edge eq reverse $edge) {
            print "symetric edge $edge \n";
            next;
        }
        my $h = $index{$edge};
        if (1 < scalar keys %$h) {
            print "ambigous \n";
            next;
        }

        my ($x, $y, $d) = @{$bs{$edge}};
        my ($e, $es) = %$h;
        # print "found $e for $edge\n";

        my @n = @$es; # sides of the piece
        while ($n[$d] ne $edge and $n[$d] ne reverse $edge) {
            rotate_p($e);
            push @n, (shift @n); # rotate left
        }
        if ($n[$d] eq $edge) { # flip is needed
            if ($d % 2) {
                flip_h($e);
                @n = map {reverse $_} @n;
            } else {
                flip_v($e);
                @n = reverse @n;
            }
        }
        merge_piece($e, $x, $y, @n);
    }
}
foreach my $x ($min_x..$max_x) {
    foreach my $y ($min_y..$max_y) {
        print "#", $bi{"$x $y"};
    }
    print "\n";
}

my @big_map;
foreach my $x ($min_x..$max_x) {
    my $first_image_of_line = $images{$bi{"$x 0"}};
    my $h = $#$first_image_of_line;
    foreach my $i (reverse (0..$h)) {
        foreach my $y ($min_y..$max_y) {
            print "  ", $images{$bi{"$x $y"}}->[$i];
        }
        push @big_map, join('', map {$images{$bi{"$x $_"}}->[$i]} $min_y..$max_y);
        print "\n";
    }
    print "\n";
}

foreach my $l (@big_map) {
    print "", $l, "\n";
}

sub merge_piece {
    my ($id, $x, $y, @sides) = @_;
    print "merging piece $id, $x, $y, @sides\n";
    $all_pieces{$id} = \@sides;
    add_boundary($sides[0], $x-1, $y, 2);
    add_boundary($sides[1], $x, $y-1, 3);
    add_boundary($sides[2], $x+1, $y, 0);
    add_boundary($sides[3], $x, $y+1, 1);
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

