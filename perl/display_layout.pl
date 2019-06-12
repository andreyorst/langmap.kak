use strict;
use utf8;
binmode STDIN, ":utf8";
binmode STDOUT, ":utf8";
binmode STDERR, ":utf8";
use Encode qw(decode_utf8);

@ARGV = map {decode_utf8($_, 1)} @ARGV;

my $name   = $ARGV[0];
my $layout = $ARGV[1];

$layout =~ s/^'|'$|'\\\'\'/'/g;

my $upper_row  = substr $layout, 0, 28;
my $qwerty_row = substr $layout, 28, 24;
my $home_row   = substr $layout, 52, 22;
my $bottom_row = substr $layout, 74;

print "evaluate-commands -client $ENV{kak_client} %🐙 info -title %{langmap for $name} %🦀$upper_row
  $qwerty_row
   $home_row
    $bottom_row🦀 🐙"
