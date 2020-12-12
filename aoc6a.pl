

my $r = 0;
my %h;

sub count {
    $r = $r + scalar( keys %h);
    %h = ();
}

foreach my $line (<>) {
    chomp $line;
    if ($line eq '') {
        count();
    } else {
        map {$h{$_}++} split '', $line;
    }
}
count();
print "sum -> $r\n";
