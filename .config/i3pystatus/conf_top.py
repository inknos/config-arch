import os, subprocess
from i3pystatus import Status, get_module

# status = Status()

status = Status(
    logfile='/home/nik/.config/i3pystatus/log_top.log',
    logformat='%(asctime)s %(levelname)s:',
)

# Displays clock like this:
# Tue 30 Jul 11:59:46 PM KW31
#                          ^-- calendar week
status.register("clock",
    format="%a %-d %b %T KW%V",
    on_leftclick="xfce4-terminal -e calcurse",)

# Shows the average load of the last minute and the last 5 minutes
# (the default value for format is used)
#status.register("load")

# Shows your CPU temperature, if you have a Intel CPU
#status.register("temp",
#    format="{Package_id_0}°C {Core_0_bar}{Core_1_bar}{Core_2_bar}{Core_3_bar}",
#    hints={"markup": "pango"},
#    lm_sensors_enabled=True,
#    color = "#1794d1",
#    alert_temp = 80,
#    alert_color = "#900000",
#)

# The battery monitor has many formatting options, see README for details

# This would look like this:
# Discharging 6h:51m
status.register("battery",
    format="{status} {remaining:%E%hh:%Mm}",
    alert=True,
    alert_percentage=5,
    status={
        "DIS":  "Discharging",
        "CHR":  "Charging",
        "FULL": "Bat full",
    },
    color = "#FFFFFF",
    charging_color = "#1794D1",
    critical_color = "#900000",
    not_present_color = "#222222",
    full_color = "#FFFFFF",
    no_text_full=True,
)

# Shows the address and up/down state of eth0. If it is up the address is shown in
# green (the default value of color_up) and the CIDR-address is shown
# (i.e. 10.10.10.42/24).
# If it's down just the interface name (eth0) will be displayed in red
# (defaults of format_down and color_down)
#
# Note: the network module requires PyPI package netifaces
#status.register("network",
#    interface="enp4s0f1",
#    hints={"markup": "pango"},
#    format_up="<span color=\"#1794d1\">{v4cidr}</span>",
#    start_color = "#999999",
#    end_color  = "#1794d1",
#    color_down = "#999999", 
#)

# Note: requires both netifaces and basiciw (for essid and quality)
status.register("network",
    interface="wlp3s0",
    hints = {"markup": "pango"},
    format_up="<span color=\"#1794d1\">{essid} {quality:03.0f}%</span>",
    start_color = "#999999",
    end_color   = "#1794d1",
    color_down  = "#999999",
    dynamic_color=True,
    divisor=1048,
)

#status.register("net_speed",
#    units="bits",
#    format="↓{speed_down:.1f}{down_units} ↑{speed_up:.1f}{up_units} ({hosting_provider})",
#    interval=300,
#    on_leftclick = ['run']
#)

# Shows pulseaudio default sink volume
#
# Note: requires libpulseaudio from PyPI
status.register("pulseaudio",
    format="♪ {volume:03.0f}% {db}dB {volume_bar}",
    vertical_bar_width=1,
    color_muted="#900000",
    on_leftclick="switch_mute",
    on_rightclick="pavucontrol",)

# Shows mpd status
# Format:
# Cloud connected▶Reroute to Remain
#status.register("mpd",
#    format="{title}{status}{album}",
#    status={
#        "pause": "▷",
#        "play": "▶",
#        "stop": "◾",
#    },)

status.register("text",
    text = "HTOP",
    on_leftclick = "xfce4-terminal -e htop",
    color = "#1794d1",
)

@get_module
def change_text_log(self, text=""):
    ison = False
    if "logkeys --start" in str(subprocess.check_output(['ps', '-ef'])):
        ison = True
    else:
        ison = False
    if text == "on":
        self.output["full_text"] = "| ● |"
        if ison == False:
            os.system('llk')
    if text == "off":
        self.output["full_text"] = "| ○ |"
        if ison == True:
            os.system('llkk')

status.register("text",
    text = "| ○ |",
    on_leftclick = [change_text_log, "on"],
    on_rightclick = [change_text_log, "off"],
    color = "#1794d1",
)

#status.register("pomodoro",
#    sound='/home/nik/Music/porcupinetree-pianolessos.m4a',
#    hints = {"markup": "pango"},
#    format = "<span color=\"#1794d1\">☯  {current_pomodoro} / {total_pomodoro} {time}</span>",
#)

status.register("now_playing",
    on_leftclick=["player_command", "PlayPause"],
    on_rightclick=["player_command", "Stop"],
    on_middleclick=["player_prop", "Shuffle", True],
    on_upscroll=["player_command", "Seek", -10000000],
    on_downscroll=["player_command", "Seek", +10000000],
    color="#1794D1",
    color_no_player="#999999",
    on_doubleleftclick=["player_command", "Next"],
    on_doublerightclick=["player_command", "Previous"],
)

status.run()
