use strict;

my @prog;
foreach my $line (<>) {
    chomp $line;
    my ($op, $operand) = split ' ', $line;
    push @prog, [$op, $operand + 0];
}

my $acc= 0;
my $pc = 0;
my %h;
my $fini = 0;
do {
    my ($op, $operand) = @{$prog[$pc]};
    print "$pc : $op $operand -> ";
    if ($op eq 'nop') {
        $pc++;
    } elsif ($op eq 'acc') {
        $acc += $operand;
        $pc++;
    } elsif ($op eq 'jmp') {
        $pc += $operand;
    } else {
        die "unknown $op $operand at line $pc";
    }
    $fini = exists $h{$pc};
    $h{$pc}++;
    print "$acc\n";
} while (! $fini);

print "acc -> $acc\n";
