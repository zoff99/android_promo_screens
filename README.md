## Create nice promotion images from boring App screenshots

### Automatically generated promo images:

<img src="https://github.com/zoff99/android_promo_screens/releases/download/nightly/output_blue.png" height="600"></a>
<img src="https://github.com/zoff99/android_promo_screens/releases/download/nightly/output_purple.png" height="600"></a>
<img src="https://github.com/zoff99/android_promo_screens/releases/download/nightly/output_orange.png" height="600"></a>
<img src="https://github.com/zoff99/android_promo_screens/releases/download/nightly/output_green.png" height="600"></a>
<img src="https://github.com/zoff99/android_promo_screens/releases/download/nightly/output_f1_green.png" height="600"></a>
<img src="https://github.com/zoff99/android_promo_screens/releases/download/nightly/output_f2_green.png" height="600"></a>

### commands:

`ImageMagick` is required
<br>

```bash
./test.sh "top text" \
  "smaller longer text describing whats going on. and also have some good motivation here." \
  testfiles/screen_shot_android_02.png purple
```
<br>

```bash
Usage:
./test.sh <top text> <long text> <android screenshot image> [<blue|purple|orange|green>]
# generated image is: output.png
```


<br>
Any use of this project's code by GitHub Copilot, past or present, is done
without our permission.  We do not consent to GitHub's use of this project's
code in Copilot.
