use strict;

my $r = 0;
my %h = ('EMPTY' => 1);

sub count {
    $r = $r + scalar( keys %h);
    %h = ('EMPTY' => 1);
}

sub add_line {
    my $line = shift;
    if (exists $h{EMPTY}) {
        %h = map { ($_ => 1) } split '', $line;
    } else {
        my %v = map { ($_ => 1) } split '', $line;
        foreach my $k (keys %h) {
            delete $h{$k} unless exists $v{$k};
        }
    }
}

foreach my $line (<>) {
    chomp $line;
    if ($line eq '') {
        count();
    } else {
        add_line ($line);
    }
}
count();
print "sum -> $r\n";
