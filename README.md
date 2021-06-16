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
