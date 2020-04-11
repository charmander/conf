hidpi="$(cat ~/conf/hi-dpi)"

if test "$hidpi" '!=' 1; then
	xrandr --newmode 1920x1080 173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
	xrandr --addmode HDMI1 1920x1080
	xrandr --output HDMI1 --mode 1920x1080
fi

setxkbmap -layout us -option compose:ralt -option caps:escape -option terminate:ctrl_alt_bksp
#feh --no-fehbg --bg-fill ~/…
xrdb ~/.Xresources

if test "$hidpi" '=' 1; then
	printf 'Xft.dpi: 192\n' | xrdb -
fi

exec spectrwm
