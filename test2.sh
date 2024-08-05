#! /bin/bash
#*********************************
#
# android_promo_screens
# (C)Zoff in 2024
#
# https://github.com/zoff99/android_promo_screens
#
#*********************************

width="1200"
height="2000"

bg_color_top_blueish="#635aef"
bg_color_top_purpleish="#972FC0"
bg_color_top_orangeish="#CC8B18"
bg_color_top_greenish="#26991A"

text_label_top_01="$1"
text_label_top_02="$2"
screen_image_file="$3"

if [ "$1""x" == "x" ]; then
    echo "ERROR: no header text given"
    exit 1
fi

if [ "$2""x" == "x" ]; then
    echo "ERROR: no top text given"
    exit 2
fi

if [ "$3""x" == "x" ]; then
    echo "ERROR: no screen image given"
    exit 3
fi

if [ ! -e "$screen_image_file" ]; then
    echo "ERROR: screen image file does not exist"
    exit 4
fi

if [ "$4""x" == "x" ]; then
    echo "INFO: using default blueish color scheme"
    bg_color_top="$bg_color_top_blueish"
elif [ "$4""x" == "purplex" ]; then
    echo "INFO: using purpleish color scheme"
    bg_color_top="$bg_color_top_purpleish"
elif [ "$4""x" == "orangex" ]; then
    echo "INFO: using orangeish color scheme"
    bg_color_top="$bg_color_top_orangeish"
elif [ "$4""x" == "greenx" ]; then
    echo "INFO: using greenish color scheme"
    bg_color_top="$bg_color_top_greenish"
fi

outputfilename="output.png"

text_label_top_01_textbox_width=$[ $width - 200 ]
text_label_top_01_textbox_height="250"
text_label_top_02_textbox_width=$[ $width - 200 ]
text_label_top_02_textbox_height="300"

bg_color_bottom="#fcfcfc"

phoneframe_width=$[ $width - 480 ]
phoneframe_height=$[ $height * 2 / 3 ]
phoneframe_start_x=$[ $[ $width - $phoneframe_width ] / 2 ]
phoneframe_start_y=$[ 520 ]
phoneframe_end_x=$[ $phoneframe_start_x + $phoneframe_width ]
bg_color_phoneframe="rgba( 0, 0, 0 , 1.0 )"
rounded_phone_frame_x=70
rounded_phone_frame_y=70
r=45

margin_screen_to_phone_x=40
delta_scr_x=$[ $margin_screen_to_phone_x / 2 ]
margin_screen_to_phone_y=50
phonescreen_start_x=$[ $phoneframe_start_x + $delta_scr_x ]
phonescreen_start_y=$[ $phoneframe_start_y + $margin_screen_to_phone_y ]
phonescreen_end_x=$[ $phoneframe_end_x - $delta_scr_x ]

phonescreen_needed_with=$[ $phonescreen_end_x - $phonescreen_start_x - 0 ]
echo "phonescreen_needed_with:$phonescreen_needed_with"


text_label_top_01_textbox_width=$[ $width - 200 ]


rm -f tmp.png


# create a rectangle image with some background
convert -size ${width}x${height} xc:"$bg_color_top" "$outputfilename"

# make the curvy line
convert "$outputfilename" -fill none -strokewidth 5 -stroke "$bg_color_bottom" \
          -draw "bezier   0,700 450,700 750,500 1200,750" "$outputfilename"

# fill the lower part, below the curvy line, with bg color
convert "$outputfilename" -fill "$bg_color_bottom" -fuzz "48%" \
          -draw 'color 1000,1900 floodfill' "$outputfilename"

# draw the large top text
convert -font "@fonts/NotoSansMono-Regular.ttf" -fill white \
          -background none \
          -stroke none \
          -gravity northwest -size "$text_label_top_01_textbox_width"x"$text_label_top_01_textbox_height" \
          caption:"$text_label_top_01" \
          "$outputfilename" +swap -gravity north -composite tmp.png
cp tmp.png "$outputfilename"

# draw the longer top text with smaller size below the large text
convert -font "@fonts/NotoSansMono-Regular.ttf" -fill white \
          -background none \
          -stroke none \
          -gravity northwest -size "$text_label_top_02_textbox_width"x"$text_label_top_02_textbox_height" \
          caption:"$text_label_top_02" \
          "$outputfilename" +swap -gravity north -geometry +0+"$text_label_top_01_textbox_height" -composite tmp.png
cp tmp.png "$outputfilename"

rm -f tmp.png

# convert the wanted screenshot to the width required to fit in the box
rm -f screen.png
convert "$screen_image_file" -resize ${phonescreen_needed_with}x8000 screen.png

screen_new_w=$(identify -ping -format '%w' screen.png 2>/dev/null)
screen_new_h=$(identify -ping -format '%h' screen.png 2>/dev/null)

echo "new screenshot size= $screen_new_w x $screen_new_h"

# now calculate the size of the phone frame, from the new screenshot height
phoneframe_end_y=$[ $phoneframe_start_y + $screen_new_h + $margin_screen_to_phone_y + $margin_screen_to_phone_y ]

# draw the black rounded rectangle of the phone frame
convert "$outputfilename" -strokewidth 0 -fill "$bg_color_phoneframe" \
   -draw "roundrectangle $phoneframe_start_x,$phoneframe_start_y $phoneframe_end_x,$phoneframe_end_y $rounded_phone_frame_x,$rounded_phone_frame_y" \
   "$outputfilename"

####################################################
####################################################
# DEBUG: draw a placeholer white rectangle to check bounds where screenshot should go
####################################################
# phonescreen_end_y=$[ $phoneframe_start_y + $phoneframe_height + 500 ] ## --> TODO: calcualte this new!!
####################################################
# convert "$outputfilename" -strokewidth 0 -fill white \
#   -draw "roundrectangle $phonescreen_start_x,$phonescreen_start_y $phonescreen_end_x,$phonescreen_end_y 60,60" \
#   "$outputfilename"
####################################################
####################################################

# give the screenshot rounded corners
rm -f screen2.png
convert screen.png \
     \( +clone  -alpha extract \
        -draw 'fill black polygon 0,0 0,'"$r"' '"$r"',0 fill white circle '"$r"','"$r"' '"$r"',0' \
        \( +clone -flip \) -compose Multiply -composite \
        \( +clone -flop \) -compose Multiply -composite \
     \) -alpha off -compose CopyOpacity -composite screen2.png
rm -f screen.png

# add screenshot over the background at the correct position
ddd=$[ $phonescreen_start_x + 0 ]
yyy=$[ $phonescreen_start_y + 0 ]
composite -geometry +${ddd}+${yyy} screen2.png "$outputfilename" "$outputfilename"
rm -f screen2.png
