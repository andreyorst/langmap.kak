use strict;
use utf8;
binmode STDIN, ":utf8";
binmode STDOUT, ":utf8";
binmode STDERR, ":utf8";
use Encode qw(decode_utf8);

@ARGV = map {decode_utf8($_, 1)} @ARGV;

my $client       = $ARGV[0]; # get current client
my $mode         = $ARGV[1]; # currently only insert and prompt mode are supported
my $default_name = $ARGV[2]; # name of the default langmap for the modeline
my $default      = $ARGV[3]; # default langmap string
my $langmap_name = $ARGV[4]; # name of the additional langmap for the modeline
my $langmap      = $ARGV[5]; # additional langmap string

$default =~ s/'\\\''/'/g; # Kakoune escapes single quote when passing option to the script
$langmap =~ s/'\\\''/'/g; # so we need to remove the escaping part from the string before split

my @default = split //, $default; # creating arrays from langmap strings
my @langmap = split //, $langmap;

if (scalar @langmap eq 0) {
    print "evaluate-commands -client $client %🐙 fail %{additional langmap is not set} 🐙";
    exit();
}

if (scalar @default gt scalar @langmap) {
    print "evaluate-commands -client $client %🐙 echo -debug %{default langmap size is greater then additional langmap size} 🐙\n";
    exit();
}

if (scalar @default eq 0 || scalar @langmap eq 0) {
    print "evaluate-commands -client $client %🐙 fail %{langmap size is zero}🐙";
    exit();
}

my $action; # action to perform: map or unmap

if ($ENV{kak_opt_langmap_toggled} eq "false") {
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
for my $i (1 .. $#default - 1) {
    print "evaluate-commands -client $client %🐙 $action buffer $mode -- %🦀$default[$i]🦀 %🦀$langmap[$i]🦀 🐙\n";
}

