use strict;

#my  ($cpk, $dpk) = (5764801, 17807724); # ex -> 14897079
my ($cpk, $dpk) = (18356117, 5909654); # input

my $loop_size = 12;

my $subject_number = 7;
my $value = 1;
my $dls = 0; # door loop size;

while ($value != $dpk) {
    $value *= $subject_number;
    $value = $value % 20201227;
    $dls++;
}

print "door loop size = $dls\n";

$value = 1;
my $cls = 0; # card loop size

while ($value != $cpk) {
    $value *= $subject_number;
    $value = $value % 20201227;
    $cls++;
}

print "card loop size = $cls\n";

print "jef : " . (7*7*7*7*7*7*7*7 % 20201227), "\n";

sub transform {
    my $subject_number = shift;
    my $loop_number = shift;
    my $value = 1;
    for my $i (1..$loop_number) {
        $value *= $subject_number;
        $value = $value % 20201227;
    }
    return $value;
}


print "key ", transform($dpk, $cls), "\n";
print "key ", transform($cpk, $dls), "\n";
