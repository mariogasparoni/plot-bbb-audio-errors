#!/bin/bash
# plot-bbb-audio-erros (c) 2021 Mario Gasparoni Junior 
#
# Freely distributed under the MIT license
#
# Show audio errors frequency of a BigBlueButton server, by 
# using the information retrieved from NGINX logs.
# 
# usage:
#   plot-erros.sh <HTML5_NGINX_LOG_FILE>
#
#   NGINX log file for bigbluebutton-html5 can be found at:
#     /var/log/nginx/bigbluebutton_html5_client.log

INPUT_FILE=$1

if [ ! -f "$INPUT_FILE" ]
then
  echo "usage:"
  echo "  plot-erros.sh <HTML5_NGINX_LOG_FILE>"
  echo ""
  echo "  NGINX logs for bigbluebutton-html5 can be found at:"
  echo "    /var/log/nginx/bigbluebutton_html5_client.log"
  exit 1;
fi

GNUPLOT_PATH=$(which gnuplot)

if [ -z "$GNUPLOT_PATH" ]
then
  echo "Gnuplot not found. You must install it to run this script."
fi

TMP_FILE_ERRORS=/tmp/bbb-errors
TMP_FILE_DATA=/tmp/bbb-data

rm -f $TMP_FILE_ERRORS
rm -f $TMP_FILE_DATA
rm -f $TMP_FILE_DATA"_tmp"

grep -oE "errorCode=[0-9]{4}" $INPUT_FILE | cut -f2 -d"=" > $TMP_FILE_ERRORS
LISTEN_ONLY_ATTEMPTS=$(grep -oE "user requested to connect to audio" \
  $INPUT_FILE | wc -l)

MIC_ATTEMPTS=$(grep -oE "User requested to join audio" $INPUT_FILE | wc -l)
TOTAL_AMOUNT_OF_ERRORS=$(wc -l < $TMP_FILE_ERRORS)
ERROR_PER_ATTEMPTS_PERCENTAGE=$(echo "scale=2;($TOTAL_AMOUNT_OF_ERRORS/(\
  $LISTEN_ONLY_ATTEMPTS+$MIC_ATTEMPTS))*100" | bc)

ERROR_CODES=(
  1002
  1004
  1005
  1006
  1007
  1008
  1010
)

for code in ${ERROR_CODES[@]}
do
  NUMBER_OF_ERRORS=$(grep -c $code $TMP_FILE_ERRORS)
  PERCENTAGE=$(echo "scale=2;($NUMBER_OF_ERRORS/$TOTAL_AMOUNT_OF_ERRORS)*\
    100" | bc)
  echo "$code $NUMBER_OF_ERRORS $PERCENTAGE%" >> $TMP_FILE_DATA"_tmp"
done

sort -n -k2 --reverse $TMP_FILE_DATA"_tmp" > $TMP_FILE_DATA

gnuplot -p -e "set xlabel \"Error Codes\\n\\n (file: $INPUT_FILE)\"; \
  set ylabel '#Total Amount of Errors (TAE): $TOTAL_AMOUNT_OF_ERRORS'; \
  set key off; set title \"Audio Errors Frequency (%) \
  \\n\\n(#Microphone Attempts (MA): $MIC_ATTEMPTS , \
  #Listen-only Attempts (LA): $LISTEN_ONLY_ATTEMPTS , \
  TAE/(MA+LA): $ERROR_PER_ATTEMPTS_PERCENTAGE%)\\n\\n\"; \
  set boxwidth 0.5;set style fill solid;plot '$TMP_FILE_DATA' \
  using 2:xtic(1) with boxes linecolor rgb '#6EC1E4', \
  '' u 0:2:3 with labels offset 0,1"
