#!/bin/bash


readonly WATCHLISTS="./watchlists.txt"
readonly UPDATE_INTERVAL_SEC=10
readonly OUTPUT_DIR="./downloads/"

check_and_download() {
    while :
    do
        url="https://frontendapi.twitcasting.tv/users/${1}/latest-movie"
        islive=`curl $url -H 'Origin: https://twitcasting.tv' -s | jq '.movie.is_on_live'`

        echo $line is_on_live: $islive

        if [ $islive = 'true' ]; then
            dl_url="http://twitcasting.tv/${1}/metastream.m3u8/?video=1"
            `ffmpeg -y -i $dl_url -c copy -map p:0 $OUTPUT_DIR$1$(date '+%Y-%m-%d_%H-%M').mp4`
        fi

        sleep $UPDATE_INTERVAL_SEC
    done
}


# FIXME: 複数ユーザー
cat $WATCHLISTS | while read line
do
    check_and_download $line
    echo process_id $!
done                                  

