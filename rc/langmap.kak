# ╭─────────────╥─────────────────────╮
# │ Author:     ║ File:               │
# │ Andrey Orst ║ langmaps.kak        │
# ╞═════════════╩═════════════════════╡
# │ Insert mode langmap switcher      │
# ╞═══════════════════════════════════╡
# │ GitHub.com/andreyorst/langmap.kak │
# ╰───────────────────────────────────╯

declare-option -docstring 'Additional langmap to use in insert mode. Must be a str-list in the following format:
lang_name lang_map. Available langmaps can be browsed with %opt{langmap_langmuage_name}' \
str-list langmap

declare-option -hidden -docstring %sh{printf "%s\n" "location of the langmap plugin root directory.
        Value: ${kak_source%/rc/*}"} \
str langmap_root %sh{printf "%s\n" "${kak_source%/rc/*}"}

# General langmaps
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
declare-option -docstring 'English key layout for US qwerty keyboards' str-list langmap_us_qwerty 'en' %{`~1!2@3#4$5%6^7&8*9(0)-_=+\|qQwWeErRtTyYuUiIoOpP[{]}aAsSdDfFgGhHjJkKlL;:'"zZxXcCvVbBnNmM,<.>/?}
declare-option -docstring 'Russian key layout for jcuken keyboards'    str-list langmap_ru_jcuken 'ru' %{ёЁ1!2"3№4;5%6:7?8*9(0)-_=+\/йЙцЦуУкКеЕнНгГшШщЩзЗхХъЪфФыЫвВаАпПрРоОлЛдДжЖэЭяЯчЧсСмМиИтТьЬбБюЮ.,}
declare-option -docstring 'French key layout for azerty keyboards'     str-list langmap_fr_azerty 'fr' %{²~&1é2"3'4(5-6è7_8ç9à0)°=+*µaAzZeErRtTyYuUiIoOpP^¨$£qQsSdDfFgGhHjJkKlLmMù%wWxXcCvVbBnN,?;.:/!§}
declare-option -docstring 'German key layout for qwertz keyboards'     str-list langmap_de_qwertz 'de' %{^°1!2"3§4$5%6&7/8(9)0=ß?´`#'qQwWeErRtTzZuUiIoOpPüÜ+*aAsSdDfFgGhHjJkKlLöÖäÄyYxXcCvVbBnNmM,;.:-_}
declare-option -docstring 'Spanish key layout for qwerty keyboards'    str-list langmap_es_qwerty 'es' %{ºª1!2"3·4$5%6&7/8(9)0='?¡¿çÇqQwWeErRtTyYuUiIoOpP`^+*aAsSdDfFgGhHjJkKlLñÑ´¨zZxXcCvVbBnNmM,;.:-_}

# Dvorak langmaps
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
declare-option -docstring 'English key layout for Dvorak keyboards' str-list langmap_us_dvorak 'en' %{`~1!2@3#4$5%6^7&8*9(0)[{]}\|'",<.>pPyYfFgGcCrRlL/?=+aAoOeEuUiIdDhHtTnNsS-_;:qQjJkKxXbBmMwWvVzZ}
declare-option -docstring 'German key layout for Dvorak keyboards'  str-list langmap_de_dvorak 'de' %{^°1!2"3§4$5%6&7/8(9)0=+*<>-_üÜ,;.:pPyYfFgGcCtTzZ?ß/\aAoOeEiIuUhHdDrRnNsSlLöÖqQjJkKxXbBmMwWvV#'}
declare-option -docstring 'Russian key layout for Dvorak keyboards' str-list langmap_ru_dvorak 'ru' %{юЮ1!2@3ё4Ё5ъ6Ъ7&8*9(0)шШщЩэЭ'",<.>пПыЫфФгГцЦрРлЛ/?чЧаАоОеЕуУиИдДхХтТнНсС-_;:яЯйЙкКьЬбБмМвВжЖзЗ}
declare-option -docstring 'French key layout for Dvorak keyboards'  str-list langmap_fr_dvorak 'fr' %{_*=1/2-3è4\5^6(7`8)9"0[+]%~#:?'<é>gG.!hHvVcCmMkKzZ¨&oOaAuUeEbBfFsStTnNdDwW;|qQ,@iIyYxXrRlLpPjJ}
declare-option -docstring 'Spanish key layout for Dvorak keyboards' str-list langmap_es_dvorak 'es' %{ºª1!2"3·4$5%6&7/8(9)0='?¡¿çÇ.:,;ñÑpPyYfFgGcChHlL`^+*aAoOeEuUiIdDrRtTnNsS´¨-_qQjJkKxXbBmMwWvVzZ}

# Macbook langmaps
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
declare-option -docstring 'English key layout for EU qwerty Macbook keyboards' str-list langmap_eu_qwerty_mac 'en' %{§±1!2@3#4$5%6^7&8*9(0)-_=+qQwWeErRtTyYuUiIoOpP[{]}aAsSdDfFgGhHjJkKlL;:'"\|`~zZxXcCvVbBnNmM,<.>/?}
declare-option -docstring 'Russian key layout for EU jcuken Macbook keyboards' str-list langmap_ru_jcuken_mac 'ru' %{><1!2"3№4%5:6,7.8;9(0)-_=+йЙцЦуУкКеЕнНгГшШщЩзЗхХъЪфФыЫвВаАпПрРоОлЛдДжЖэЭёЁ][яЯчЧсСмМиИтТьЬбБюЮ/?}

declare-option -hidden str langmap_current_lang 'en'
declare-option -hidden bool langmap_toggled false

declare-option -docstring 'Default langmap to use as a reference to bind insert mode keys. This langmap should be exactly the same as your keyboard keys. US QWERTY is used by default' \
str-list langmap_default %opt{langmap_us_qwerty}

declare-option -docstring 'Additional langmap to use in insert mode. Must be a str-list in the following format:
lang_name lang_map. Available langmaps can be browsed with %opt{langmap_langmuage_name}' \
str-list langmap

provide-module langmap %{

# Code
# ‾‾‾‾
define-command -override -docstring "toggle-langmap <mode>: toggle between keyboard langmaps in insert mode only" \
toggle-langmap -params ..1 %{ evaluate-commands -client %val{client} %sh{
    map_mode=${1:-insert}
    # $kak_opt_langmap_toggled $kak_client
    perl $kak_opt_langmap_root/perl/langmap.pl $map_mode $kak_opt_langmap_default $kak_opt_langmap | kak -p $kak_session
}}

define-command -docstring 'langmap-display-layout <langmap>: display <langmap> option value in info box formatted as keyboard layout. Accepts ''%opt{langmap_lang_map}'' or str-list formatted langmap as a parameter' \
langmap-display-layout -params 2 %{ evaluate-commands %sh{
    # $kak_client
    perl $kak_opt_langmap_root/perl/display_layout.pl $@ | kak -p $kak_session
}}

}

# powerline.kak support
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
hook global ModuleLoaded powerline %{ require-module langmap_powerline }

provide-module langmap_powerline %{

declare-option -hidden str-list powerline_modules
set-option -add global powerline_modules 'langmap'

declare-option -hidden bool powerline_module_langmap true
define-command -hidden powerline-langmap %{
    require-module langmap
    remove-hooks global langmap-loader
    evaluate-commands %sh{
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
    }
}

define-command -hidden powerline-toggle-langmap -params ..1 %{ evaluate-commands %sh{
    [ "$kak_opt_powerline_module_langmap" = "true" ] && value=false || value=true
    if [ -n "$1" ]; then
        [ "$1" = "on" ] && value=true || value=false
    fi
    printf "%s\n" "set-option global powerline_module_langmap $value"
    printf "%s\n" "powerline-rebuild"
}}

}
