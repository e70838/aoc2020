

my @trees;
my %h = ();
my $nb_valid = 0;
foreach my $line (<>) {
    chomp $line;
    if ($line eq '') {
        check_passport();
        %h = ();
    } else {
        foreach my $data (split (' ', $line)) {
            my ($key, $value) = split ':', $data;
            $h{$key} = $value;
        }
    }
}
check_passport();


sub check_passport {
    my %req = map {($_=> 1)} qw (byr iyr eyr hgt hcl ecl pid); # not cid
    foreach my $k (keys %h) {
        delete $req{$k};
    }
    print join('#', sort keys %h), ' ==> ', join ('#', sort keys %req), "\n";
    $nb_valid++ unless scalar %req;
}

print $nb_valid . "\n";

