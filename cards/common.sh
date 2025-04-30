#!/bin/bash

do_img=1

if ! command -v textimg &> /dev/null
then
    printf "warn: textimg is not installed\n"
    printf "      https://github.com/ggerganov/textimg\n"
    printf "\n"
    printf "only text output will be generated\n"

    do_img=0
fi

# colors
C0="\x1b[0m"

#CT="\x1b[48;2;155;255;255m\x1b[38;2;029;161;242m"
CT="\x1b[49m\x1b[0m\x1b[38;2;000;000;000m"
CR="\x1b[49m\x1b[0m\x1b[38;2;205;008;008m"
CL="\x1b[49m\x1b[0m\x1b[38;2;035;008;165m"

CC="\x1b[49m\x1b[0m\x1b[38;2;080;080;080m"
TC="\x1b[49m\x1b[1m\x1b[48;2;000;000;000m\x1b[38;2;238;238;238m"
TA="\x1b[49m\x1b[1m\x1b[48;2;000;000;000m\x1b[38;2;110;225;110m"
TH="\x1b[49m\x1b[1m\x1b[48;2;000;000;000m\x1b[38;2;160;160;160m"
TO="\x1b[49m\x1b[1m\x1b[48;2;000;000;000m\x1b[38;2;238;138;070m"
TW="\x1b[49m\x1b[1m\x1b[48;2;000;000;000m\x1b[38;2;255;255;255m"
CG="\x1b[49m\x1b[0m\x1b[38;2;000;255;124m"
CY="\x1b[49m\x1b[0m\x1b[38;2;255;238;110m"
CO="\x1b[49m\x1b[0m\x1b[38;2;208;058;050m"
#CA="\x1b[49m\x1b[0m\x1b[38;2;035;008;165m"
CA="\x1b[49m\x1b[0m\x1b[38;2;000;000;000m"

#CT="\x1b[49m\x1b[0m\x1b[38;2;029;161;242m"
#CR="\x1b[49m\x1b[0m\x1b[38;2;255;048;048m"
#
#CC="\x1b[49m\x1b[0m\x1b[38;2;255;255;255m"
#CB="\x1b[49m\x1b[1m\x1b[38;2;255;255;255m"
#CG="\x1b[49m\x1b[0m\x1b[38;2;000;255;124m"
#CY="\x1b[49m\x1b[0m\x1b[38;2;255;238;110m"

# params
p_s="4.0"

p_fs=$(bc <<< "20*${p_s}")
p_fs=${p_fs%.*}

p_sw=$(bc <<< "1.5*${p_s}")

# line height
p_lh=$(bc <<< "0.75*(1.2*${p_fs})")
p_lh=${p_lh%.*}

#echo "line height = ${p_lh}"

# frame
p_fx0=$(bc <<< "0.50*${p_lh}")
p_fy0=$(bc <<< "0.90*${p_lh}")

p_fr=$(bc <<< "8.0*${p_s}")

function gg_add_frame {
    fname=$1

    # bg

    magick ${fname} -ping -format "%wx%h" info: | xargs -I{} magick -size {} xc:"rgba(188,188,188,255)" bg.png

    # frame

    x0=$(bc <<< "${p_fx0}")
    y0=$(bc <<< "${p_fy0}")

    x1="%[fx:w - $(bc <<< "${p_fx0} + 4*${p_s}")]"
    y1="%[fx:h - $(bc <<< "${p_fy0}")]"

    magick ${fname} \
        -format "
    roundrectangle ${x0},${y0} ${x1},${y1} ${p_fr},${p_fr};
    " \
        info: > frame.mvg

    magick ${fname} -border 0 -alpha transparent \
        -background none -fill "rgba(238,238,238,255)" -stroke none \
        -draw "@frame.mvg"    frame-bg.png

    magick ${fname} -border 0 -alpha transparent \
        -background none -fill none -stroke black -strokewidth $p_sw \
        -draw "@frame.mvg"    frame.png

    # shadow

    x0="$(bc <<< "${p_fx0} + 3*${p_s}")"
    y0="$(bc <<< "${p_fy0} + 4*${p_s}")"

    x1="%[fx:w - $(bc <<< "${p_fx0} - 2*${p_s}")]"
    y1="%[fx:h - $(bc <<< "${p_fy0} - 4*${p_s}")]"

    magick ${fname} \
        -format "
    roundrectangle ${x0},${y0} ${x1},${y1} ${p_fr},${p_fr};
    " \
        info: > shadow0.mvg

    magick ${fname} -border 0 -alpha transparent \
        -background none -fill darkgray -stroke darkgray -strokewidth $p_sw \
        -draw "@shadow0.mvg"    shadow0.png

    x0="$(bc <<< "${p_fx0} + 1*${p_s}")"
    y0="$(bc <<< "${p_fy0} + 2*${p_s}")"

    x1="%[fx:w - $(bc <<< "${p_fx0} + 1*${p_s}")]"
    y1="%[fx:h - $(bc <<< "${p_fy0} - 2*${p_s}")]"

    magick ${fname} \
        -format "
    roundrectangle ${x0},${y0} ${x1},${y1} ${p_fr},${p_fr};
    " \
        info: > shadow1.mvg

    magick ${fname} -border 0 -alpha transparent \
        -background none -fill gray -stroke gray -strokewidth $p_sw \
        -draw "@shadow1.mvg"    shadow1.png

    # title

    x0=$(bc <<< "${p_fx0}")
    y0=$(bc <<< "${p_fy0} + 1.50*${p_lh}")

    x1="%[fx:w - $(bc <<< "${p_fx0} + 4*${p_s}")]"
    y1=${y0}

    magick ${fname} \
        -format "
    line           ${x0},${y0} ${x1},${y1};
    " \
        info: > title.mvg

    magick ${fname} -border 0 -alpha transparent \
        -background none -fill none -stroke gray -strokewidth $p_sw \
        -draw "@title.mvg"    title.png

    #magick ${fname} -border 0 -alpha transparent \
    #    -background none -fill white -stroke none -strokewidth 0 \
    #    -draw "@frame.mvg"    frame-mask.png

    #frame-mask.png -compose DstIn -composite \
    magick ${fname} -alpha set -bordercolor none -border 0  \
        bg.png       -compose Over -composite \
        shadow0.png  -compose Over -composite \
        shadow1.png  -compose Over -composite \
        frame-bg.png -compose Over -composite \
        title.png    -compose Over -composite \
        frame.png    -compose Over -composite \
        ${fname}     -compose Over -composite \
        ${fname}

    x0=$(bc <<< "${p_fx0} + 0.10*${p_lh}")
    y0=$(bc <<< "${p_fy0} + 0.05*${p_lh}")

    lw=$(bc <<< "1.5*${p_lh}")
    lh=$(bc <<< "1.5*${p_lh}")

    composite -geometry ${lw}x${lh}+${x0}+${y0} ../logo/ggml-logo-transparent.png ${fname} ${fname}
}
