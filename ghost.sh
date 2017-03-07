#!/bin/bash

IP_ADDRESS=159.203.90.215
THEMES_DIR=$HOME/www/ghost/apps/ghost/htdocs/content/themes
REMOTE_THEMES_DIR=/var/www/ghost/content/themes/

cd $THEMES_DIR
rm -rf aspire.zip
echo '===>> Removed aspire.zip'

zip -r aspire.zip aspire -x *node_modules* *bower_components* *git* *.DS_Store* *.ds_store*
echo '===>> Zipped to aspire.zip'

scp aspire.zip root@$IP_ADDRESS:$REMOTE_THEMES_DIR
echo '===>> Pushed to the server 🚀'

ssh -t -t root@$IP_ADDRESS << EOT

cd $REMOTE_THEMES_DIR
rm -rf aspire
echo '===>> Removed aspire'

unzip -o aspire.zip
echo '===>> Un Zipped'

rm -rf aspire.zip
echo '===>> Removed aspire.zip'

sudo service aspire restart
echo '===>> Aspire Restarted'
echo '===>> Done 👍'

exit 1

EOT