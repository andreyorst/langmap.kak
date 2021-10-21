# langmap.kak

If you use more than one keyboard layout that you toggle with your keyboard
shortcut, you know that Kakoune won't respond to your key-presses in normal mode
unless you use layout that consist only from Latin letters. This is because
[Kakoune can only have access to the unicode characters, not keys itself][1]. So
if you want to type something in insert or prompt mode in non Latin language,
when you go back to normal mode you have to swithc layout back to Latin
language. This is a common problem for most terminal application.

This plugin is aimed to bring support of various languages to insert and prompt
mode within Kakoune. That is, with this plugin you'll be able to toggle layout
within Kakoune, without changing your operating system layout.

## Installation
### With [plug.kak][2]
Add this to your `kakrc`:

``` sh
plug "andreyorst/langmap.kak" config %{
    # add needed extra layout, for example Russian 'йцукен'
    set-option global langmap %opt{langmap_ru_jcuken}
} demand "langmap" %{
    # optional: mappings to toggle langmap
    map -docstring "toggle layout" global normal '<c-\>' ':      toggle-langmap<ret>'
    map -docstring "toggle layout" global insert '<c-\>' '<a-;>: toggle-langmap<ret>'
    map -docstring "toggle layout" global prompt '<c-\>' '<a-;>: toggle-langmap prompt<ret>'
}
```

Restart Kakoune, or re-source your `kakrc` and call `:plug-install`
command. After that you'll be able to use **langmap.kak**

### Without plugin manager
Clone this repository somewhere:

``` sh
git clone https://github.com/andreyorst/langmap.kak
```

And put `langmap.kak` file to your `autoload` or source it manually form `kakrc`
and configure.

## Configuration
If the keyboard layout you're using is listed among `langmap_lang_map` options,
all you need to do if set `langmap` option to desired variant:

``` sh
set-option global langmap %opt{langmap_ru_jcuken}
```

If you're using layout than US `qwerty`, you need to modify `langmap_default`
layout in the same way.

However if the layout you're using isn't present in this plugin, you'll have to
set it manually and assign it to new option. In order for this plugin to work
correctly, this option must be a `str-list` type, and store language name as
it's first element, and all keyboard layout keys as a second element. For
example, let's add Russian and English layouts for European Mac keyboard:

```
declare-option str-list langmap_ru_jcuken_mac 'ru' %{><1!2"3№4%5:6,7.8;9(0)-_=+йЙцЦуУкКеЕнНгГшШщЩзЗхХъЪфФыЫвВаАпПрРоОлЛдДжЖэЭёЁ][яЯчЧсСмМиИтТьЬбБюЮ/?}
declare-option str-list langmap_eu_qwerty_mac 'en' %{§±1!2@3#4$5%6^7&8*9(0)-_=+qQwWeErRtTyYuUiIoOpP[{]}aAsSdDfFgGhHjJkKlL;:'"\|`~zZxXcCvVbBnNmM,<.>/?}
```

Now, if we want to use Kakoune on European Mac keyboard, we can assign these
options to `langmap_default` and `langmap`:

```
set-option global langmap_default %opt{langmap_eu_qwerty_mac}
set-option global langmap %opt{langmap_ru_jcuken_mac}
```

Of course these layouts are shipped with the plugin, but I don't have access to
many keyboards, therefore I can't add most of the different layouts, so I will
highly appreciate pull requests with additional langmaps. Check the order of
keys in `langmap_us_qwerty` option. Usually it looks like this:

    `~1!2@3#4$5%6^7&8*9(0)-_=+\| # for the upper row
      qQwWeErRtTyYuUiIoOpP[{]}   # for the qwerty row
       aAsSdDfFgGhHjJkKlL;:'"    # for the home row
        zZxXcCvVbBnNmM,<.>/?     # for the bottom row

Combined in single line. Note that despite the fact that <kbd>\\</kbd> on most
keyboards is on the `qwerty` row, I've put it on the `upper` row because it is
like so on my keyboards, and it was easier to add layouts this way. I've used it
to add most layouts featured with this plugin, as well as Dvorak variants. If
this will cause problems when adding langmas I'm open to tweak that.

## [powerline.kak][3] and `modeline` support
This plugin supports **powerline.kak** plugin, and adds a `langmap` module to
`powerline_modules`. You can add this module to your `powerline_format`.

If you don't use **powerline.kak** you can add current active langmap indicator
to Kakoune's builtin modeline by using `langmap_current_lang` option.

[1]: https://github.com/mawww/kakoune/issues/2151#issuecomment-399678003
[2]: https://github.com/andreyorst/plug.kak
[3]: https://github.com/andreyorst/powerline.kak
