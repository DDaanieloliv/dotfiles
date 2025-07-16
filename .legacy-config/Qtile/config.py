# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.



from libqtile import bar, layout, qtile, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile import hook
from libqtile.widget import base
import os
from libqtile.config import Click, Drag
from libqtile import widget
from libqtile.widget import base
from libqtile.popup import Popup
from libqtile import qtile
import subprocess
import subprocess
from qtile_extras.popup import PopupMenu  # Corrigido o import
from qtile_extras.popup.menu import PopupMenu, PopupMenuItem, PopupMenuSeparator


mod = "mod4"
terminal = guess_terminal()

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key([mod], "b", lazy.spawn("firefox")),
    Key([mod], "f", lazy.spawn("pcmanfm")),
    Key([mod], "a", lazy.spawn("rofi -show drun")),
    Key([mod], "T", lazy.spawn("rofi -show window")),

    Key([mod], "F1", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%")),  # Super + F1: Aumentar
    Key([mod], "F2", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%")),  # Super + F2: Diminuir
    Key([mod], "F3", lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")), # Super + F3: Mutar
]

# Add key bindings to switch VTs in Wayland.
# We can't check qtile.core.name in default config as it is loaded before qtile is started
# We therefore defer the check until the key binding is run by using .when(func=...)
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )


groups = [Group(str(i+1), label="") for i in range(5)]
for i in groups:
    keys.extend(
        [
            # mod + group number = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc=f"Switch to group {i.name}",
            ),
            # mod + shift + group number = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc=f"Switch to & move focused window to group {i.name}",
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod + shift + group number = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )


layouts = [
    layout.Bsp(
        border_width=1,
        margin=8,  # Espaço extra entre janelas e borda da tela
        ratio=0.6,  # Proporção da janela principal
        border_focus="#00000000",  # Cor quando em foco
        border_normal="#00000000",      # Cor da borda quando não está em foco (adicione esta linha)
        single_border_width=0,         # Remove bordas internas entre janelas (opcional)
        fair=False,
        grow_amount=1,
    ),
    layout.Max(
        margin=8,  # Espaço extra entre janelas e borda da tela
        ratio=0.6,  # Proporção da janela principal
    )
    #layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
    #layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]



widget_defaults = dict(
    font="FiraCode Nerd Font",
    fontsize=12,
    padding=3,
    # background="#25539c",
    rounded=True,
)
extension_defaults = widget_defaults.copy()


#Colors
colorPalette = {
    "flamingo": "#F3CDCD",
    "mauve": "#DDB6F2",
    "pink": "#f5c2e7",
    "maroon": "#e8a2af",
    "red": "#f28fad",
    "peach": "#f8bd96",
    "yellow": "#fae3b0",
    "green": "#abe9b3",
    "teal": "#b4e8e0",
    "blue": "#96cdfb",
    "sky": "#89dceb",
    "white": "#d9e0ee",
    "gray": "#6e6c7e",
    "black": "#1a1826",

    "blush-coral": "#db7f8e",
    "periwinkle-blue": "#9dabc7",
    "periwinkle-gray": "#8296ba",
    "soft-denim-blue": "#5d7cb3",
    "glaucous": "#7b8dc7",
    "pine-green": "#4ab590",

    "lavender": "#a7aacc",  # Adicione esta cor
    "hover-blue": "#a0c4ff",  # Azul mais claro para hover
    "red": "#c21111",
        }


def create_power_menu():
    # Itens do menu
    menu_items = [
        PopupMenuItem(
            text="  shutdown",
            background="#a82525",
            font="firacode nerd font bold",
            fontsize="14",
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn("systemctl poweroff")
            }
        ),
        PopupMenuSeparator(),
        PopupMenuItem(
            text="  Reboot",
            font="firacode nerd font bold",
            fontsize="14",
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn("systemctl reboot")
            }

        ),
        PopupMenuSeparator(),
        PopupMenuItem(
            text="  Logout",
            font="firacode nerd font bold",
            fontsize="14",
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_shutdown()
            }
        )
    ]

    # Configurações do menu
    menu_config = {
        "background": "#0d151a",
        "foreground": "#f8f8f2",
        "highlight_color": "#bd93f9",
        "border": "#00000000",
        "border_width": 1,
        "opacity": 1,
        "font": "FiraCode Nerd Font Bold",
        "fontsize": 18,
        "width": 200,
        "hide_on_mouse_leave": True,
        "close_on_click": True,
        #"pos_x": 20,
    }

    # Cria e mostra o menu
    menu = PopupMenu.generate(
        qtile=qtile,
        menuitems=menu_items,
        **menu_config
    )
    #menu.show(relative_to=2, relative_to_bar=True)
    menu.show(x=795, y=32)





class HoverTextBox(widget.TextBox):
    def __init__(self, **config):
        super().__init__(**config)
        self.default_fg = config.get("foreground", "#fafafa")
        self.hover_fg = colorPalette["lavender"]
        self.hover_timer = None  # Adicione esta linha

    def mouse_enter(self, *args, **kwargs):
        self.foreground = self.hover_fg
        self.bar.draw()
        # Abre o menu após um pequeno delay (0.3 segundos)
        self.hover_timer = qtile.call_later(0.3, self.open_menu)

    def mouse_leave(self, *args, **kwargs):
        self.foreground = self.default_fg
        self.bar.draw()
        # Cancela o timer se o mouse sair antes do delay
        if self.hover_timer:
            self.hover_timer.cancel()
            self.hover_timer = None

    def open_menu(self):
        self.hover_timer = None
        create_power_menu()





power_widget = HoverTextBox(
    text=" 󱄅 ",
    font="FiraCode Nerd Font Bold",
    fontsize=25,
    padding=10,
    foreground="#fafafa",
    background="#00000000",
    mouse_callbacks={
        "Button1": create_power_menu,
        "Button2": create_power_menu,
    },
)

#power_widget = widget.TextBox(
#    text=" 󱄅 ",
#    font="FiraCode Nerd Font Bold",
#    fontsize=25,
#    padding=10,
#    foreground="#fafafa",
#    background="#00000000",
#    highlight_method="text",
#    mouse_callbacks={
#        "Button1": create_power_menu,
#        "Button2": create_power_menu,
#        "EnterNotify": handle_power_widget_hover,  # Quando o mouse entra
#        "LeaveNotify": handle_power_widget_leave,  # Quando o mouse sai
#    },
#)

def get_widgets(primary=False):
    widgets = [
        widget.Spacer(
            length=3,
            background="#00000000",
            ),
        widget.TextBox(
            text="",
            padding=0,
            fontsize=20,
            foreground=colorPalette["periwinkle-blue"],
            background="#00000000",
            ),
        widget.GroupBox(
            this_current_screen_border=None,
            highlight_method="line",
            background=colorPalette["periwinkle-blue"],
            highlight_color=[colorPalette["periwinkle-blue"], colorPalette["periwinkle-blue"]],
            inactive=colorPalette["black"],
            ),
        widget.TextBox(
            text="",
            padding=0,
            fontsize=20,
            foreground=colorPalette["periwinkle-blue"],
            background="#00000000",
            ),
       widget.TextBox(
           text="",
           padding=0,
           fontsize=20,
           foreground=colorPalette["periwinkle-gray"],
           background="#00000000",
           ),
        widget.Wlan(
           interface="wlp2s0",
           font="FiraCode Nerd Font Bold",
           format='<span font="FiraCode Nerd Font">󰤨</span>  {percent:2.0%}',
           disconnected_message='<span font="FiraCode Nerd Font">󰤮</span>',
           foreground=colorPalette["white"],
           background=colorPalette["periwinkle-gray"],
           padding=8,
           fontsize=12,
           ),
        widget.TextBox(
           text="",
           padding=0,
           fontsize=20,
           foreground=colorPalette["periwinkle-gray"],
           background="#00000000",
           ),
        widget.WindowName(
            fontsize=12,
            font="FiraCode Nerd Font Bold",
            foreground="#ebf5ee",
            max_chars=47,
            fmt="{}...",
            ),

        power_widget,

       #widget.TextBox(
       #    background="#00000000",
       #    fmt=" 󱄅 ",
       #    padding=0,
       #    font="FiraCode Nerd Font Bold",
       #    fontsize=25,
       #    foreground="#fafafa",
       #    mouse_callbacks={
       #        "Button1": create_power_menu,
       #        "Button2": create_power_menu
       #    },
       #    ),
        widget.Spacer(
            length=2,
            background="#00000000",
            ),
       #widget.TextBox(
       #    text="",
       #    padding=0,
       #    fontsize=20,
       #    foreground=colorPalette["blush-coral"],
       #    background="#00000000",
       #    ),
       #widget.Mpris2(
       #    name="firefox",  # Ou "chromium" dependendo do navegador
       #    foreground=colorPalette["blush-coral"],
       #    background="#1a1826",
       #    format="{xesam:title} - {xesam:artist}",
       #    scroll_chars=None,
       #    stop_pause_text=" ",
       #    paused_text=" ",
       #    playing_text=" "
       #    ),
       #widget.Cmus(
       #    foreground="#1a2e20",  # Cor do texto
       #    background=colorPalette["blush-coral"],  # Cor de fundo
       #    format="{artist} - {title}",  # Formato padrão
       #    no_artist_format="{title}",  # Formato quando não há artista
       #    playing_text=" ",  # Ícone de reprodução (Nerd Font)
       #    paused_text=" ",  # Ícone de pausa
       #    stopped_text=" ",  # Ícone de parado
       #    mouse_callbacks={
       #        'Button1': lazy.spawn("cmus-remote -u"),  # Clica no PRÓPRIO ÍCONE/TEXTO para play/pause
       #        'Button4': lazy.spawn("cmus-remote -n"),  # Scroll UP = próxima música
       #        'Button5': lazy.spawn("cmus-remote -r"),   # Scroll DOWN = música anterior
       #    },
       #    playing_color="#50fa7b",  # Verde quando tocando
       #    paused_color="#ffb86c",  # Laranja quando pausado
       #    stopped_color="#ff5555",  # Vermelho quando parado
       #    update_interval=1,  # Atualização a cada 1 segundo
       #    font="FiraCode Nerd Font",
       #    markup=True,
       #    padding=8,
       #    fontsize=12,
       #    stream_format="📻 {stream}",# Mostra o nome da estação
       #    max_chars=12,
       #    ),

       #widget.TextBox(
       #   text="",
       #   padding=0,
       #   fontsize=20,
       #   foreground=colorPalette["blush-coral"],
       #   background="#00000000",
       #   ),
        widget.TextBox(
            text="",
            padding=0,
            fontsize=20,
            foreground=colorPalette["soft-denim-blue"],
            background="#00000000",
            ),
        widget.Battery(
            font="FiraCode Nerd Font Bold",
            format='<span>󰁹</span> {percent:2.0%}',
            foreground=colorPalette["black"],
            background=colorPalette["soft-denim-blue"],
            ),
        widget.TextBox(
            text="",
            padding=0,
            fontsize=20,
            foreground=colorPalette["soft-denim-blue"],
            background="#00000000",
            ),
        widget.TextBox(
            text="",
            padding=0,
            fontsize=20,
            foreground=colorPalette["glaucous"],
            background="#00000000",
            ),
        widget.CPU(
            font="FiraCode Nerd Font Bold",
            format=" {load_percent:04}%",
            foreground=colorPalette["black"],
            background=colorPalette["glaucous"],
            ),
        widget.TextBox(
            text="",
            padding=0,
            fontsize=20,
            foreground=colorPalette["glaucous"],
            background="#00000000",
            ),
        widget.TextBox(
            text="",
            padding=0,
            fontsize=20,
            foreground=colorPalette["pine-green"],
            background="#00000000",
            ),
        widget.Clock(
            font="FiraCode Nerd Font Bold",
            format=" %I:%M %p    %Y-%m-%d %a",
            foreground=colorPalette["black"],
            background=colorPalette["pine-green"],
            ),
        widget.TextBox(
            text="",
            padding=0,
            fontsize=20,
            foreground=colorPalette["pine-green"],
            background="#00000000",
            ),

        widget.Spacer(
            length=0,
            background="#00000000",
            ),
       #widget.TextBox(
       #    text="",
       #    padding=0,
       #    fontsize=20,
       #    foreground=colorPalette["red"],
       #    background="#00000000",
       #    ),
       #widget.TextBox(
       #    text="",  # Ícone de energia
       #    font="FiraCode Nerd Font Bold",
       #    fontsize=16,
       #    background=colorPalette["red"],
       #    foreground=colorPalette["black"],
       #    padding=8,
       #    mouse_callbacks={
       #        'Button1': lazy.spawn("""
       #        rofi -show power-menu -modi power-menu:~/.config/qtile/scripts/rofi-power-menu.sh
       #""")}
       #    ),
       #widget.QuickExit(
       #    font="FiraCode Nerd Font Bold",
       #    background=colorPalette["red"],
       #    fontsize=16,
       #    padding=4,
       #    foreground=colorPalette["black"],
       #    countdown_format="",
       #    countdown_start=1,
       #    default_text="",
       #    mouse_callbacks={
       #        'Button1': lazy.spawn("shutdown now")  # Sobrescreve o comportamento padrão
       #    }
       #    ),
       #widget.TextBox(
       #    text="",
       #    padding=0,
       #    fontsize=20,
       #    foreground=colorPalette["red"],
       #    background="#00000000",
       #    ),

        widget.Spacer(
            length=3,
            background="#00000000",
            ),
            ]
    if primary:
        widgets.insert(10, widget.Systray())
    return widgets


screens = [
    Screen(
        top=bar.Bar(
            get_widgets(primary=True),
            22,
            background="#00000000",
            margin=3,
           # [

                # widget.CurrentLayout(),
               # widget.GroupBox(
               #     this_current_screen_border="#00000000",
               #     rounded=True,
               # ),
               # widget.Prompt(),
               # widget.WindowName(
               # ),
               # widget.Chord(
               #     chords_colors={
               #         "launch": ("#ff0000", "#ffffff"),
               #     },
               #     name_transform=lambda name: name.upper(),
               # ),
                # widget.TextBox("default config", name="default"),
                # widget.TextBox("Press &lt;M-r&gt; to spawn", foreground="#d75f5f"),
                # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
                # widget.StatusNotifier(),
               # widget.Systray(),
                # widget.Net(interface="enp1s0", format='{down:.0f}{down_suffix} ↓↑ {up:.0f}'),
               # widget.Clock(
               #     format="   %Y-%m-%d %a %I:%M %p",
                    # background="#282a36cc",
               # ),
               # widget.Battery(
               #     format='<span>󰁹</span>  {percent:2.0%}',
               #     font="Nerd Font",
               #     fontsize=14,
               #     padding=8,
               #     foreground='#ffffff',
               #     markup=True,
               # ),
               # widget.CurrentLayout(),
                # widget.QuickExit(),
           # ],
           # 24,
           # margin=3,
           # background="#00000000",  # Barra totalmente transparente
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
        # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
        # By default we handle these events delayed to already improve performance, however your system might still be struggling
        # This variable is set to None (no cap) by default, but you can set it to 60 to indicate that you limit it to 60 events per second
        # x11_drag_polling_rate = 60,
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),

]



dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = True
floats_kept_above = True
cursor_warp = True
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# xcursor theme (string or None) and size (integer) for Wayland backend
wl_xcursor_theme = None
wl_xcursor_size = 24

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
