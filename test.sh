#! /bin/bash

width="1200"
height="2000"

outputfilename="output.png"

text_label_top_01_textbox_width=$[ $width - 200 ]
text_label_top_01_textbox_height="200"
text_label_top_02_textbox_width=$[ $width - 200 ]
text_label_top_02_textbox_height="200"

bg_color_top="#635aef"
bg_color_bottom="#fcfcfc"


text_label_top_01="You're in control."
text_label_top_02="You decide who you see in your home feed. No surprises."

#  -size ${width}x${height}

# create a rectangle image with some background
convert -size ${width}x${height} xc:"$bg_color_top" "$outputfilename"

# convert "$outputfilename" -strokewidth 0 -fill "rgba( 255, 215, 0 , 0.5 )" -draw "rectangle 66,50 200,150" "$outputfilename"

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

# montage -size ${width}x${height} "$outputfilename" -size 100x60 xc:skyblue -fill white -stroke black \
# -draw "roundrectangle 20,10 80,50 20,15" "$outputfilename"

