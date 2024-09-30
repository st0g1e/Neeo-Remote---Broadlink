#!/usr/bin/perl

my @lines;
my $location = $ARGV[1];

my $buttonText = "";

$buttonText .= "     \"##BUTTON##\": {\n";
$buttonText .= "        \"label\":\"##BUTTON_LOWER##\",\n";
$buttonText .= "        \"type\":\"mqtt\",\n";
$buttonText .= "        \"command\":\"{ \\\"topic\\\":\\\"meta/broadlink\\\", \\\"message\\\": { \\\"location\\\": \\\"##LOCATION##\\\", \\\"type\\\":\\\"##TYPE##\\\", \\\"brand\\\":\\\"##BRAND##\\\", \\\"series\\\":\\\"##SERIES##\\\", \\\"button\\\":\\\"##BUTTON##\\\" }}\"\n";
$buttonText .= "      }\n";


&readFile($ARGV[0]);
&parseJSON();

sub readFile {
  my $file = $_[0];
  chomp( $file );

  open(FILE, $file) or die "File '$file' can't be opened\n";
  @lines = <FILE>;
  close(FILE);

  shift(@lines);
}

sub parseJSON {
  my $prevSeries = "";
  foreach my $curLine (@lines) {
    chomp($curLine);

    my ($type, $brand, $series, $button, $label, $notes, $ir64, $irHex) = split(',', $curLine);

    if ( $prevSeries !~ m/^$series$/ ) {
       print "$type -> $brand -> $series\n";
       print "--------------------------\n";

       $prevSeries = $series;
    }

    my $newBtnText = $buttonText;
    my $lowerBtn = lc $button;
    $lowerBtn =~ s/^([a-z])/\u$1/;

    $newBtnText =~ s/##BUTTON##/$button/g;
    $newBtnText =~ s/##BUTTON_LOWER##/$lowerBtn/g;
    $newBtnText =~ s/##LOCATION##/$location/g;
    $newBtnText =~ s/##TYPE##/$type/g;
    $newBtnText =~ s/##BRAND##/$brand/g;
    $newBtnText =~ s/##SERIES##/$series/g;

    print "$newBtnText\n\n";
  } 
}
