

sub seat_to_number {
    my @boarding_pass = split '', shift;
    my @char_for_one = split '', 'BBBBBBBRRR';
    my $r = 0;
    for my $i (0..9) {
        $r *= 2;
        $r++ if $boarding_pass[$i] eq $char_for_one[$i];
    }
    return $r;
}

my $highest = -1;
foreach my $line (<>) {
    chomp $line;
    my $num = seat_to_number($line);
    print "$line -> $num\n";
    $highest = $num if $num > $highest;
}
print "highest -> $highest\n";
