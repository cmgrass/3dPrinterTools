# ----- Run raspberry MIPI CSI-2 Camera -----
# Notes:
#   - This assumes drivers already installed on Raspbian GNU/Linux 9 (stretch).
#   - Driver install comes from octoprint wiki setup.
#   - Tweaks may be required on newer, or alternate debian based OS.
#   - I need to test adding this to OctoPrint's "launch.sh".
# 
# 20180105 cmgrass
#




# params
CMDPATH="/home/pi/mjpg-streamer/mjpg-streamer-experimental/"
MINVAL=5
MAXVAL=20

# dry
arg_error_out()
{
  echo "Usage: $0 <fps>" >&2
  echo "  where $MINVAL <= <fps> <= $MAXVAL, and <fps> == frames per second"
  exit 1
}

exec_error_out()
{
  echo "Error executing camera."
  echo "Try enabling camera in the pi config:"
  echo "  -> $ sudo raspi-config"
  echo "    -> Interfacing Options"
  echo "      -> Camera"
  echo "        -> Enable Camera?"
  echo "          -> Yes"
}

post_urls()
{
  echo "--- URLS ---"
  echo "  Browser:"
  echo "    http://<your Raspi's IP>:8080/?action=stream"
  echo "\n  Octoprint Config Paths:"
  echo "    Stream URL: /webcam/?action=stream"
  echo "    Snapshot URL: http://127.0.0.1:8080/?action=snapshot"
  echo "    Path to FFMPEG: /usr/bin/ffmpeg\n\n"
}

# validate args
if [ $# -ne 1 ]; then
  arg_error_out
fi

if [ "$1" -lt $MINVAL ]; then
  arg_error_out
fi

if [ "$1" -gt $MAXVAL ]; then
  arg_error_out
fi

# primary command
post_urls
#  - (cd <path> && exec <cmd>) <-- Parentheses spawn sub-shell, changes
#                                  woring directory to <path>, then
#                                  executes <cmd>. Upon exit, return
#                                  from shell script was called from.
#
(cd $CMDPATH && exec $CMDPATH\/mjpg_streamer -i "./input_raspicam.so -fps $1" -o "./output_http.so") 

if [ $? -eq 0 ]; then
  exit 0
else
  exec_error_out
fi
