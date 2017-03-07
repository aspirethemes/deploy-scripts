#!/bin/bash

IP_ADDRESS=107.170.4.135
THEMES_DIR=$HOME/www/aspire/wp-content/themes/
REMOTE_THEMES_DIR=/srv/users/serverpilot/apps/wordpress/public/wp-content/themes/

cd $THEMES_DIR
rm -rf aspire.zip
echo '===>> Removed aspire.zip ❌'

zip -r aspire.zip aspire -x *git* *node_modules* *bower_components* *.DS_Store* *.ds_store* *.editorconfig* *.jshintignore* *.jshintrc* *.vscode* *.vscode*
echo '===>> Zipped to aspire.zip'

scp $THEMES_DIR/aspire.zip root@$IP_ADDRESS:$REMOTE_THEMES_DIR
echo '===>> Pushed to the server 🚀'

ssh -t -t root@$IP_ADDRESS << EOT

cd $REMOTE_THEMES_DIR
rm -rf aspire
echo '===>> Removed aspire'

unzip -o aspire.zip
echo '===>> Un Zipped'

rm -rf aspire.zip
echo '===>> Removed aspire.zip'
echo '===>> Done 👍'

exit 1

EOT