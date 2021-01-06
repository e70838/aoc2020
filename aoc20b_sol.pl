
# https://www.reddit.com/r/adventofcode/comments/kgo01p/2020_day_20_solutions/ghugqq4?utm_source=share&utm_medium=web2x&context=3
$/ = "";
my %tiles = map {/Tile (\d+):\n([\n.#]+)\n/m} <>;
my $n = int sqrt keys %tiles;

sub dims {
    my @lines = split /\n/, $_[0];
    length($lines[0]), scalar(@lines)
}

sub rot90 {
    my ($w, $h) = dims $_[0];
    join '', map {
        my $y=$_; (map {substr($_[0], ($w+1)*$_+$h-$y-1, 1)} 0..$w-1), "\n"
    } 0..$h-1
}

sub flip {
    join "\n", reverse split /\n/, $_[0];
}

sub trans {
    my ($tile) = @_; my @trans;
    for (1..4) {push @trans, $tile; $tile = rot90($tile);}
    $tile = flip($tile);
    for (1..4) {push @trans, $tile; $tile = rot90($tile);}
    @trans;
}

sub top { (split /\n/, $_[0])[0] }
sub right { top(rot90($_[0])) }
sub bottom { top(flip($_[0])) }
sub left { bottom(rot90($_[0])) }

my %sides = ('top' => \&top,
             'right' => \&right,
             'bottom' => \&bottom,
             'left' => \&left);

my %edges; my @all_tiles;

while (my ($num, $tile) = each %tiles) {
    my @trans = trans $tile;
    for my $i (0..7) {
        my $id = "$num!$i";
        push @all_tiles, $id;
        while (my ($side, $fn) = each %sides) {
            my $edge = $fn->($trans[$i]);
            $edges{$id}{$side} = $edge;
            push @{$edges{$side}{$edge}}, $id;
        }
    }
}

my %used; my @board;

sub fill {
    my ($i, $j) = @_;
    return 1 if $i==$n;
    my @left; my @top; my @choices;
    @left = @{$edges{'left'}{$edges{$board[$i][$j-1]}{'right'}}} if $j>0;
    @top = @{$edges{'top'}{$edges{$board[$i-1][$j]}{'bottom'}}} if $i>0;
    if ($i==0 && $j==0) {
        @choices = @all_tiles
    } elsif ($i == 0) {
        @choices = @left;
    } elsif ($j == 0) {
        @choices = @top;
    } else {
        my %in_top = map {$_ => 1} @top;
        @choices = grep {$in_top{$_}} @left;
    }
    for my $id (@choices) {
        my ($num) = $id =~ /(\d+)!\d/;
        next if $seen{$num}++;
        $board[$i][$j] = $id;
        return 1 if fill($j==$n-1 ? ($i+1, 0) : ($i, $j+1));
        delete $seen{$num};
    }
    return 0;
}

fill(0,0);

sub at { my ($i,$j) = @_; $board[$i][$j] =~ /(\d+)!\d/; $1 }

print "Part 1: ", at(0,0) * at($n-1,0) * at(0,$n-1) * at($n-1,$n-1), "\n";

sub peel { local $_ = $_[0]; s/^.*\n//; s/\n.*$//; s/^.//gm; s/.$//gm; $_; }

sub hcat {
    my @lines = map {[split /\n/, $_]} @_;
    join "\n", map {my $i=$_; join '', map {$_->[$i]} @lines} 0..@{$lines[0]}-1;
}

sub tile {
    my ($i,$j) = @_; $board[$i][$j] =~ /(\d+)!(\d)/;
    (trans $tiles{$1})[$2]
}

my $map = join "\n",
    map { my $i=$_; hcat map {peel tile($i,$_)} 0..$n-1 } 0..$n-1;

my @monster = ("..................#.",
               "#....##....##....###",
               ".#..#..#..#..#..#...");
my $x = length($monster[0]);  my $y = @monster;

use List::Util qw(sum all);

sub monsters {
    my @map = split /\n/, $_[0];
    my $w = length($map[0]); my $h = @map;
    sum map {
        my $i=$_;
        map {
            my $j=$_;
            all {substr($map[$i+$_],$j) =~ /^$monster[$_]/} 0..$y-1} 0..$w-$x
    } 0..$h-$y;
}

sub pixels { join('', @_) =~ tr/#// }

print "Part 2: ",
    pixels($map) - pixels(@monster) * sum map {monsters $_} trans $map;
