#! /bin/bash

width="1200"
height="2000"

outputfilename="output.png"

text_label_top_01_textbox_width=$[ $width - 200 ]
text_label_top_01_textbox_height="250"
text_label_top_02_textbox_width=$[ $width - 200 ]
text_label_top_02_textbox_height="300"

bg_color_top="#635aef"
bg_color_bottom="#fcfcfc"

phoneframe_width=$[ $width - 300 ]
phoneframe_height=$[ $height * 2 / 3 ]
phoneframe_start_x=$[ $[ $width - $phoneframe_width ] / 2 ]
phoneframe_start_y=$[ $[ $height / 3 ] + 60 ]
phoneframe_end_x=$[ $phoneframe_start_x + $phoneframe_width ]
phoneframe_end_y=$[ $phoneframe_start_y + $phoneframe_height + 500 ]
bg_color_phoneframe="rgba( 0, 0, 0 , 1.0 )"

text_label_top_01_textbox_width=$[ $width - 200 ]

text_label_top_01="You're in control."
text_label_top_02="You decide who you see in your home feed. No surprises."

#  -size ${width}x${height}

# create a rectangle image with some background
convert -size ${width}x${height} xc:"$bg_color_top" "$outputfilename"

convert "$outputfilename" -fill none -strokewidth 5 -stroke "$bg_color_bottom" \
          -draw "bezier   0,1200 450,1200 750,700 1200,900" "$outputfilename"
#           -draw "path 'M 0,1200   Q 450,1200 750,700   T 1200,900' " "$outputfilename"

convert "$outputfilename" -fill "$bg_color_bottom" -fuzz "48%" \
          -draw 'color 1000,1900 floodfill' "$outputfilename"


convert -font "@fonts/NotoSansMono-Regular.ttf" -fill white \
          -background none \
          -gravity northwest -size "$text_label_top_01_textbox_width"x"$text_label_top_01_textbox_height" \
          caption:"$text_label_top_01" \
          "$outputfilename" +swap -gravity north -composite tmp.png
cp tmp.png "$outputfilename"


convert -font "@fonts/NotoSansMono-Regular.ttf" -fill white \
           -background none \
          -gravity northwest -size "$text_label_top_02_textbox_width"x"$text_label_top_02_textbox_height" \
          caption:"$text_label_top_02" \
          "$outputfilename" +swap -gravity north -geometry +0+"$text_label_top_01_textbox_height" -composite tmp.png
cp tmp.png "$outputfilename"

rm -f tmp.png

# draw the black rounded rectangle that the phone frame
convert "$outputfilename" -strokewidth 0 -fill "$bg_color_phoneframe" \
   -draw "roundrectangle $phoneframe_start_x,$phoneframe_start_y $phoneframe_end_x,$phoneframe_end_y 60,60" \
   "$outputfilename"


# montage -size ${width}x${height} "$outputfilename" -size 100x60 xc:skyblue -fill white -stroke black \
# -draw "roundrectangle 20,10 80,50 20,15" "$outputfilename"

