use strict;

my @prog;
foreach my $line (<>) {
    chomp $line;
    my ($op, $operand) = split ' ', $line;
    push @prog, [$op, $operand + 0];
}

my $acc;
sub test_prog {
    my $i = shift;
    $acc= 0;
    my $pc = 0;
    my %h = ();
    do {
        my ($op, $operand) = @{$prog[$pc]};
        #print "$pc : $op $operand -> ";
        if ($op eq 'nop') {
            $pc++;
        } elsif ($op eq 'acc') {
            $acc += $operand;
            $pc++;
        } elsif ($op eq 'jmp') {
            $pc += $operand;
            return if $pc < 0;
            return if $pc > scalar @prog;
        } else {
            die "unknown $op $operand at line $pc";
        }
        return if exists $h{$pc}; # no infinite loop
        $h{$pc}++;
        die "success $i $acc" if $pc == scalar @prog;
    } while (1);
}

foreach my $i (0..$#prog) {
    if ($prog[$i]->[0] eq 'nop') {
        $prog[$i]->[0] = 'jmp';
        test_prog($i);
        $prog[$i]->[0] = 'nop';
    } elsif ($prog[$i]->[0] eq 'jmp') {
        $prog[$i]->[0] = 'nop';
        test_prog($i);
        $prog[$i]->[0] = 'jmp';
    }
}
