#!/bin/bash

DATE=$(date "+%Y-%m-%d")
TS=$(echo $(($(date +%s%N)/1000000)))
SOURCE="Terra"	#Choose between : Terra & Aqua

cd /tmp/

/usr/bin/wget -t 1 'https://wvs.earthdata.nasa.gov/api/v1/snapshot?REQUEST=GetSnapshot&LAYERS=MODIS_'${SOURCE}'_CorrectedReflectance_TrueColor&CRS=EPSG:4326&TIME='${DATE}'&BBOX=41.23,-11.71,51.91,15.905&FORMAT=image/jpeg&WIDTH=6284&HEIGHT=2430&AUTOSCALE=TRUE&ts='${TS}'&DOWNLOAD=yes' -O tmp.jpg	#Download image

if [ $(echo "100 * $(/usr/bin/identify -verbose tmp.jpg | grep 'Image statistics' -A 8 | grep 'entropy' | cut -d ':' -f 2) > 95" | bc) ]
then
    /usr/bin/convert /tmp/tmp.jpg -resize 1920 /tmp/tmp_resize.jpg
    /usr/bin/convert /tmp/tmp_resize.jpg -crop 1920x1080+0+0 /tmp/wallpaper.jpg
fi

rm /tmp/tmp.jpg /tmp/tmp_resize.jpg
mv /tmp/wallpaper.jpg $HOME/Images/
