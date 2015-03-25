#!/bin/bash

archive_dir="archive"
#cat \#sailfishos-porters.2014-06-26.log.html | grep 'class="nick"' | sed -e 's^<tr id="t\([^"]*\)"><[^>]*>\([^<]*\)</th><td[^>]*>\(.*\)^\1  \2    \3^; s^</td><[^<]*><[^<]*>[^>]*</a></td></tr>$^^'

curl 'http://www.merproject.org/logs/%23sailfishos-porters/%23sailfishos-porters.2014-06-26.log.html' | grep 'class="nick"' | sed -e 's^<tr id="t\([^"]*\)"><[^>]*>\([^<]*\)</th><td[^>]*>\(.*\)^\1  \2    \3^; s^</td><[^<]*><[^<]*>[^>]*</a></td></tr>$^^' > 2014-06-26.txt
