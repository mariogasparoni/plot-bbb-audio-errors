## plot-bbb-audio-erros (c) 2021 Mario Gasparoni Junior 
#### Freely distributed under the MIT license

This script shows audio errors frequency of a BigBlueButton server, by 
using the information retrieved from NGINX logs.

## Depencies:
* Gnuplot

## Usage:
```bash
    plot-bbb-audio-erros.sh <HTML5_NGINX_LOG_FILE>
```
NGINX log file for bigbluebutton-html5 can be found at:
 `/var/log/nginx/bigbluebutton_html5_client.log`

## Plotting data from multiple servers
You can simply concatenate logs from multiple files into a new one and then call the script with this new file. You can run:
```bash
cat <HTML_NGINX_LOG_FILE_1> <HTML_NGINX_LOG_FILE_2> ... > <NEW_FILE>
```
and then:
```bash
plot-bbb-audio-errors.sh <NEW_FILE>
```

## More info
Tested in BigBlueButton version 2.3+