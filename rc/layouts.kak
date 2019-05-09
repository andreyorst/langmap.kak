# ╭─────────────╥─────────────────────╮
# │ Author:     ║ File:               │
# │ Andrey Orst ║ langmaps.kak        │
# ╞═════════════╩═════════════════════╡
# │ Insert mode langmap switcher      │
# ╞═══════════════════════════════════╡
# │ GitHub.com/andreyorst/langmap.kak │
# ╰───────────────────────────────────╯

declare-option -hidden bool langmap_installed true

# Langmaps
# ‾‾‾‾‾‾‾‾
declare-option str-list langmap_us_qwerty     'en' %{`~1!2@3#4$5%6^7&8*9(0)-_=+\|qQwWeErRtTyYuUiIoOpP[{]}aAsSdDfFgGhHjJkKlL;:'"zZxXcCvVbBnNmM,<.>/?}
declare-option str-list langmap_eu_qwerty_mac 'en' %{§±1!2@3#4$5%6^7&8*9(0)-_=+qQwWeErRtTyYuUiIoOpP[{]}aAsSdDfFgGhHjJkKlL;:'"\|`~zZxXcCvVbBnNmM,<.>/?}
declare-option str-list langmap_ru_jcuken     'ru' %{ёЁ1!2"3№4;5%6:7?8*9(0)-_=+\/йЙцЦуУкКеЕнНгГшШщЩзЗхХъЪфФыЫвВаАпПрРоОлЛдДжЖэЭяЯчЧсСмМиИтТьЬбБюЮ.,}
declare-option str-list langmap_ru_jcuken_mac 'ru' %{><1!2"3№4%5:6,7.8;9(0)-_=+йЙцЦуУкКеЕнНгГшШщЩзЗхХъЪфФыЫвВаАпПрРоОлЛдДжЖэЭёЁ][яЯчЧсСмМиИтТьЬбБюЮ/?}

declare-option -hidden str langmap_current_lang 'en'
declare-option -hidden bool langmap_toggled false

declare-option -docstring 'Default langmap to use as a reference to bind insert mode keys. This langmap should be exactly the same as your keyboard keys. US QWERTY is used by default' \
str-list langmap_default %opt{langmap_us_qwerty}
declare-option -docstring 'Additional langmap to use in insert mode. Must be a str-list in the following format:
lang_name lang_map. Available langmaps can be browsed with %opt{langmap_langmuage_name}' \
str-list langmap

# Code
# ‾‾‾‾
hook -once global WinSetOption langmap=.* %{ require-module langmap }

provide-module langmap %🐙

define-command -override -docstring "toggle-langmap <mode>: toggle between keyboard langmaps in insert mode only" \
toggle-langmap -params ..1 %{ evaluate-commands %sh{
    map_mode=${1:-insert}
    perl -CAEIO -e '
        use strict;
        use utf8;

        my $mode         = $ARGV[0]; # currently only insert and prompt mode are supported
        my $default_name = $ARGV[1]; # name of the default langmap for the modeline
        my $default      = $ARGV[2]; # default langmap string
        my $langmap_name = $ARGV[3]; # name of the additional langmap for the modeline
        my $langmap      = $ARGV[4]; # additional langmap string

        $default =~ s/\\'\'\''//g; # Kakoune escapes single quote when passing option to the script
        $langmap =~ s/\\'\'\''//g; # so we need to remove the escaping part from the string before split

        my @default = split //, $default; # creating arrays from langmap strings
        my @langmap = split //, $langmap;

        if (scalar @default gt scalar @langmap) {
            print "fail %{default langmap size is greater then additional langmap size}";
            exit();
        }

        if (scalar @default eq 0 || scalar @langmap eq 0) {
            print "fail %{langmap size is zero}";
            exit();
        }

        my $action; # action to perform: map or unmap

        if ($ENV{kak_opt_langmap_toggled} eq "false") {
            $action = "map";
            if ($mode eq "insert") {
                print "set-option global langmap_current_lang $langmap_name\n";
            }
            print "set-option global langmap_toggled true\n";
        } else {
            $action = "unmap";
            if ($mode eq "insert") {
                print "set-option global langmap_current_lang $default_name\n";
            }
            print "set-option global langmap_toggled false\n";
        }

        # this loop maps our keys based on langmaps, but since first and last items are single
        # quotes added by Kakoune we skip them
        for my $i (1 .. $#default - 1) {
            print "$action buffer $mode -- %🦀$default[$i]🦀 %🦀$langmap[$i]🦀\n";
        }
    ' $map_mode $kak_opt_langmap_default $kak_opt_langmap
}}

🐙

# powerline.kak support
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
hook global WinSetOption powerline_loaded=true %{ require-module langmap_powerline }

provide-module langmap_powerline %🦀

declare-option -hidden str-list powerline_modules
set-option -add global powerline_modules 'langmap'

declare-option -hidden bool powerline_module_langmap true
define-command -hidden powerline-langmap %{ evaluate-commands %sh{
    default=$kak_opt_powerline_base_bg
    next_bg=$kak_opt_powerline_next_bg
    normal=$kak_opt_powerline_separator
    thin=$kak_opt_powerline_separator_thin
    if [ "$kak_opt_powerline_module_langmap" = "true" ]; then
        bg=$kak_opt_powerline_color11
        fg=$kak_opt_powerline_color10
        [ "$next_bg" = "$bg" ] && separator="{$fg,$bg}$thin" || separator="{$bg,${next_bg:-$default}}$normal"
        printf "%s\n" "set-option -add global powerlinefmt %{$separator{$fg,$bg} %opt{langmap_current_lang} }"
        printf "%s\n" "set-option global powerline_next_bg $bg"
    fi
}}

define-command -hidden powerline-toggle-langmap -params ..1 %{ evaluate-commands %sh{
    [ "$kak_opt_powerline_module_langmap" = "true" ] && value=false || value=true
    if [ -n "$1" ]; then
        [ "$1" = "on" ] && value=true || value=false
    fi
    printf "%s\n" "set-option global powerline_module_langmap $value"
    printf "%s\n" "powerline-rebuild"
}}

🦀

