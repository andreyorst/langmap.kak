use strict;
use utf8;
binmode STDIN, ":utf8";
binmode STDOUT, ":utf8";
binmode STDERR, ":utf8";
use Encode qw(decode_utf8);

@ARGV = map {decode_utf8($_, 1)} @ARGV;

my $mode         = $ARGV[0]; # currently only insert and prompt mode are supported
my $default_name = $ARGV[1]; # name of the default langmap for the modeline
my $default      = $ARGV[2]; # default langmap string
my $langmap_name = $ARGV[3]; # name of the additional langmap for the modeline
my $langmap      = $ARGV[4]; # additional langmap string

my $action; # action to perform: map or unmap
my $client = $ENV{kak_client}; # current client

$default =~ s/^'|'$|'\\\'\'/'/g; # Kakoune quotes options and escapes single quotes inside when passing options to
$langmap =~ s/^'|'$|'\\\'\'/'/g; # script, so we need to remove the escaping part and wrapping quotes before split

# creating arrays from langmap strings
my @default = split //, $default;
my @langmap = split //, $langmap;

if (scalar @langmap eq 0) {
    print "evaluate-commands -client $client %🐙 fail %{additional langmap is not set} 🐙\n";
    exit();
}

if (scalar @default gt scalar @langmap) {
    print "evaluate-commands -client $client %🐙 echo -debug %{default langmap size is greater then additional langmap size} 🐙\n";
    exit();
}

if (scalar @default eq 0 || scalar @langmap eq 0) {
    print "evaluate-commands -client $client %🐙 fail %{langmap size is zero} 🐙\n";
    exit();
}

if ($ENV{"kak_opt_langmap_toggled"} eq "false") {
    $action = "map";
    if ($mode eq "insert") {
        print "evaluate-commands -client $client %🐙 set-option buffer langmap_current_lang $langmap_name 🐙\n";
    }
    print "evaluate-commands -client $client %🐙 set-option buffer langmap_toggled true 🐙\n";
} else {
    $action = "unmap";
    if ($mode eq "insert") {
        print "evaluate-commands -client $client %🐙 set-option buffer langmap_current_lang $default_name 🐙\n";
    }
    print "evaluate-commands -client $client %🐙 set-option buffer langmap_toggled false 🐙\n";
}

# this loop maps our keys based on langmaps, but since first and last items are single
# quotes added by Kakoune we skip them
for my $i (0 .. $#default) {
    print "evaluate-commands -client $client %🐙 $action buffer $mode -- %🦀$default[$i]🦀 %🦀$langmap[$i]🦀 🐙\n";
}

