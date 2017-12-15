from i3pystatus import Status
# from i3pystatus.mail import maildir
from i3pystatus.updates import pacman, yaourt

# status = Status()

status = Status(
    logfile='/home/nik/.config/i3pystatus/log_bottom.log',
    logformat='%(asctime)s %(levelname)s:',
)

# Displays clock like this:
# Tue 30 Jul 11:59:46 PM KW31
#                          ^-- calendar week
status.register("clock",
    format="%a %-d %b %X KW%V",)

# Shows the average load of the last minute and the last 5 minutes
# (the default value for format is used)
status.register("load")

# Shows your CPU temperature, if you have a Intel CPU
status.register("temp",
    format="[{Core_0} {Core_1} {Core_2} {Core_3}]°C",
    hints={"markup": "pango"},
    lm_sensors_enabled=True,
    color = "#1794d1",
    alert_temp = 80,
    alert_color = "#900000",    
)

# The battery monitor has many formatting options, see README for details

# This would look like this, when discharging (or charging)
# ↓14.22W 56.15% [77.81%] 2h:41m
# And like this if full:
# =14.22W 100.0% [91.21%]
#
# This would also display a desktop notification (via D-Bus) if the percentage
# goes below 5 percent while discharging. The block will also color RED.
# If you don't have a desktop notification demon yet, take a look at dunst:
#   http://www.knopwob.org/dunst/
status.register("battery",
    format="{status}/{consumption:.2f}W {percentage:.2f}% {remaining:%E%hh:%Mm}",
    alert=True,
    alert_percentage=15,
    status={
        "DPL": "DPL",
        "DIS": "↓",
        "CHR": "↑",
        "FULL": "=",
    },
    color = "#FFFFFF",
    charging_color = "#1794D1",
    critical_color = "#900000",
    not_present_color = "#222222",
    full_color = "#ffffff",
    no_text_full=True,
)

# Displays whether a DHCP client is running
status.register("runwatch",
    name="DHCP",
    path="/var/run/dhclient*.pid",
    color_up = "#1794d1",
    color_down = "#999999")

# Shows the address and up/down state of eth0. If it is up the address is shown in
# green (the default value of color_up) and the CIDR-address is shown
# (i.e. 10.10.10.42/24).
# If it's down just the interface name (eth0) will be displayed in red
# (defaults of format_down and color_down)
#
# Note: the network module requires PyPI package netifaces
status.register("network",
    interface="enp4s0f1",
    hints={"markup": "pango"},
    format_up="<span color=\"#1794d1\">{v4cidr}</span>",
    start_color = "#999999",
    end_color  = "#1794d1",
    color_down = "#999999",
)

# Note: requires both netifaces and basiciw (for essid and quality)
status.register("network",
    interface="wlp3s0",
    hints = {"markup": "pango"},
    format_up="<span color=\"#1794d1\">{essid} {quality:03.0f}%</span>",
    start_color = "#999999",
    end_color   = "#1794d1",
    color_down  = "#999999",
)

# Shows disk usage of /
# Format:
# 42/128G [86G]
status.register("disk",
    path="/",
    format="{used}/{total}G [{avail}G]",)

# Shows mpd status
# Format:
# Cloud connected▶Reroute to Remain
status.register("mpd",
    format="{title}{status}{album}",
    status={
        "pause": "▷",
        "play": "▶",
        "stop": "◾",
    },)

#keyboard layout
status.register("xkblayout", layouts=["us", "it"])

# keyboard locks
status.register("keyboard_locks",
    format = "{caps} {num} {scroll}",
    hints = {"markup": "pango"},
    caps_on    = "<span color=\"#1794d1\">CAP</span>",
    caps_off   = "<span color=\"#999999\">___</span>",
    num_on     = "<span color=\"#1794d1\">CAP</span>",
    num_off    = "<span color=\"#999999\">___</span>",
    scroll_on  = "<span color=\"#1794d1\">CAP</span>",
    scroll_off = "<span color=\"#999999\">___</span>",
    color = "#999999",
)

status.register("updates", 
    backends = [pacman.Pacman(), yaourt.Yaourt()],
    color="#1794D1",
)

status.run()
