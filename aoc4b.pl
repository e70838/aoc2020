

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
    my ($byr, $iyr, $eyr, $hgt, $hcl, $ecl, $pid) = @h{qw (byr iyr eyr hgt hcl ecl pid)};
    if ($byr !~ m/^\d\d\d\d$/) {
        print "byr $byr not digits\n";
    } elsif ($byr < 1920 || $byr > 2002) {
        print "byr $byr out of bound\n";
    } elsif ($iyr  !~ m/^\d\d\d\d$/) {
        print "iyr $iyr not digits\n";
    } elsif ($iyr < 2010 || $iyr > 2020) {
        print "iyr $iyr out of bound\n";
    } elsif ($eyr  !~ m/^\d\d\d\d$/) {
        print "eyr $eyr not digits\n";
    } elsif ($eyr < 2020 || $eyr > 2030) {
        print "eyr $eyr out of bound\n";
    } elsif ($hcl !~ m/^#[0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]$/) {
        print "hcl $hcl wrong syntax\n";
    } elsif ($ecl !~ m/^amb|blu|brn|gry|grn|hzl|oth$/) {
        print "ecl $ecl wrong syntax\n";
    } elsif ($pid !~ m/^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]$/) {
        print "pid $pid wrong syntax\n";
    } else {
        my ($height, $h_unit) = $hgt =~ m/^(\d+)(cm|in)$/;
        if ( ($h_unit eq 'cm' && $height >= 150 && $height <= 193)
             || ($h_unit eq 'in' && $height >= 59 && $height <= 76) ) {
            $nb_valid++;
        } else {
            print "hgt $hgt invalid\n";
        }
    }
}

print $nb_valid . "\n";

