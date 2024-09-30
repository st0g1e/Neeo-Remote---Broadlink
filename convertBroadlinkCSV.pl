#!/usr/bin/perl

my @lines;
my $SPACE = 2;

&readFile($ARGV[0]);

open(FILE, ">broadlinkData.json") or die "can't open broadlinkNew.josn to write\n";
&parseJSON();
close(FILE);

sub readFile {
  my $file = $_[0];
  chomp( $file );

  open(FILE, $file) or die "File '$file' can't be opened\n";
  @lines = <FILE>;
  close(FILE);

  shift(@lines);
}

sub parseJSON {
  my $prevType = "";
  my $prevBrand = "";
  my $prevSeries = "";
  my $prevButton = "";

  &printWithSpace(0, "{");
 
  foreach my $curLine (@lines) {
    chomp($curLine);

    my ($type, $brand, $series, $button, $label, $notes, $ir64, $irHex) = split(',', $curLine);
   
    # PRINT TYPES
    if ( $prevType !~ m/^$type$/ ) {
       if ( $prevType !~ m/^$/ ) {
         &printWithSpace(0, "\n");
         &printWithSpace(3, "}\n");
         &printWithSpace(2, "}\n");
         &printWithSpace(1, "},");
       }

       &printWithSpace(0,"\n");
       &printWithSpace(1, "\"$type\": {");

       $prevType = $type;
       $prevBrand = "";
       $prevSeries = "";
       $prevButton = "";
    }

    # PRINT BRANDS
    if ( $prevBrand !~ m/^$brand$/ ) {
       if ( $prevBrand !~ m/^$/ ) {
         &printWithSpace(0, "\n");
         &printWithSpace(3, "}");
         &printWithSpace(0, "\n");
         &printWithSpace(2, "},");
       }

       &printWithSpace(0, "\n"); 
       &printWithSpace(2, "\"$brand\": {"); 

       $prevBrand = $brand;
       $prevSeries = "";
       $prevButton = "";
    }

    # PRINT SERIES
    if ( $prevSeries !~ m/^$series$/ ) {
       if ( $prevSeries !~ m/^$/ ) {
         &printWithSpace(0, "\n");
         &printWithSpace(3, "},");
       }

       &printWithSpace(0, "\n");
       &printWithSpace(3, "\"$series\": {");

       $prevSeries= $series;
       $prevButton = "";
    }

    # PRINT BUTTON DETAILS
     if ( $prevButton !~ m/^$/ ) {
       &printWithSpace(0, ",");
     }

     &printWithSpace(0, "\n");
     &printWithSpace(4, "\"$button\": {\n");
     &printWithSpace(5, "\"Label\": \"$label\",\n");
     &printWithSpace(5, "\"IR\": \"$ir64\"\n");
     &printWithSpace(4, "}");
     $prevButton= $button;
  }

  &printWithSpace(4, "\n");
  &printWithSpace(3, "}\n");
  &printWithSpace(2, "}\n");
  &printWithSpace(1, "}\n");
  &printWithSpace(0, "}\n");
}

sub printWithSpace {
  my ($level, $text) = @_;

  for (my $i = 0; $i < $level * $SPACE; $i++ ) {
    print FILE " ";
  }

  print FILE "$text";
}

sub decodeBase64 {
  return `echo $_[0] | base64 --decode`;
}

sub encodeToBase64 {
  return `echo "$_[0]" | base64`;
}
