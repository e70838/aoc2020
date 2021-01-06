use strict;

my %p; # puzzle pieces
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
    my $i = shift;
    my $a = $p{$id};
    foreach my $border (@$a) {
        delete $index{$border}->{$id};
        delete $index{$border} unless keys %{$index{$border}};
        my $rb = reverse $border;
        delete $index{$rb}->{$id};
        delete $index{$rb} unless keys %{$index{$rb}};
    }
}

# find the pieces that must be borders
my %borders;
foreach my $i (keys %p) {
    my @sides = @{$p{$i}};
    foreach my $si (0 .. $#sides) {
        my %same_border = %{$index{$sides[0]}};
        if (1 == keys %same_border) {
            print "$i\n";
            if (exists $borders{$i}) {
                #print "$i is a corner\n";
            } else {
                $borders{$i} = [@sides];
            }
        } 
        push @sides, (shift @sides);
    }
}

die "fii";

sub neighboors {
    my $i = shift;
    my @border = @{$p{$i}};
    my %r;
    foreach my $d (@border) {
        foreach my $neighboor (keys %{$index{$d}}) {
            $r{$neighboor}++;
        }
    }
    delete $r{$i};
    return keys %r;
}

my @corners;
foreach my $i (sort keys %p) {
    push @corners, $i if (2 == neighboors($i));
}

# by lack we have 3 corners. I guess the puzzle is 12*12
my $y = 0;
my $c = $corners[0];
my @solved = ([$c]); # first x, then y
remove_from_index($c);
while (exists $index{$p{$c}->[0]} or exists $index{$p{$c}->[1]}) {
    rotate ($c);
}

sub reach_second_corner {
    my $i = $solved[$#solved]->[0];
    my $right_side = $p{i}->[2];
    my @ns = keys %{$index{$right_side}};
    foreach my $n (@ns) {
    }
}


sub rotate {
    my $id = shift;
    my @a = @{$p{$id}};
    push @a, (shift @a);
    $p{$id} = \@a;
}

# find all candidates on a location and all the orientations
sub find_candidate {
    my ($x, $y) = @;
}

sub nb_candidate {
    my ($x, $y) = @_;

}

