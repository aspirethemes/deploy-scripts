#!/bin/bash

# Get Those values From Arguments
# Example, aspire-ghost 1.0.1
THEME=$1
THEME_VERSION=$2


# Split Theme into Name and Type
THEME_NAME=${THEME%-*} # aspire
THEME_TYPE=${THEME#*-} # ghost


# Remote Server Settings
GHOST_IP_ADDRESS=159.203.90.215
WORDPRESS_IP_ADDRESS=107.170.4.135

GHOST_REMOTE_THEMES_DIR=/var/www/$THEME_NAME/content/themes/
WORDPRESS_REMOTE_THEMES_DIR=/srv/users/serverpilot/apps/$THEME_NAME/public/wp-content/themes/


LOCAL_THEMES_DIR=~

# Define themes local directory
if [ $THEME_TYPE = 'wordpress' ]
then
  LOCAL_THEMES_DIR=$HOME/www/aspire/wp-content/themes/
elif [ $THEME_TYPE = 'ghost' ]
then
  LOCAL_THEMES_DIR=$HOME/www/ghost/content/themes
  cd $LOCAL_THEMES_DIR
  rm -rf $THEME_NAME.zip
  echo "===>> Removed $THEME_NAME.zip ❌"
  ZIP_COMMAND=$(zip -r $THEME_NAME.zip $THEME_NAME -x *node_modules* *bower_components* *git* *.DS_Store* *.ds_store*)
  echo "===>> Zipped to $THEME_NAME.zip 📦"
elif [ $THEME_TYPE = 'jekyll' ]
then
  LOCAL_THEMES_DIR=$HOME/www/
  cd $LOCAL_THEMES_DIR
  ZIP_COMMAND=$(zip -r $THEME_NAME.zip east -x *git* *.DS_Store* *.ds_store* *.sass-cache* *_site* *_posts/*.** *images/posts/*.** *images/pages/*.** *_pages/style-guide.md*)
fi


##============================================
# Zip the Theme
##============================================

# cd $LOCAL_THEMES_DIR
# ZIP_COMMAND=$(zip -r $THEME_NAME.zip $THEME_NAME -x *git* *node_modules* *bower_components* *.DS_Store* *.ds_store* *.editorconfig* *.jshintignore* *.jshintrc* *.vscode* *.vscode* *screenshot.png*)

# rm -rf $THEME_NAME.zip
# echo "===>> Removed $THEME_NAME.zip ❌"

# zip -r $THEME_NAME.zip $THEME_NAME -x *git* *node_modules* *bower_components* *.DS_Store* *.ds_store* *.editorconfig* *.jshintignore* *.jshintrc* *.vscode* *.vscode* #*screenshot.png*
# echo "===>> Zipped WordPress theme to $THEME_NAME.zip 📦"


##============================================
# Move the Theme to Dropbox Folder With
# Version Name to Be Ready for Themeforest
##============================================

FINAL_THEME_DIR=$HOME/Dropbox/AspireThemes/Themes/Ghost/$THEME_NAME/$THEME_NAME\ $THEME_VERSION

cp -rf  $HOME/Dropbox/AspireThemes/Themes/Ghost/$THEME_NAME/skeleton "$FINAL_THEME_DIR"
echo "===>> Skeleton is copied 📨"

cp -rf $THEME_NAME.zip "$FINAL_THEME_DIR/$THEME_NAME/Theme/For Ghost 1.0 Version"
echo "===>> theme is copied 📨"

cd $HOME/Dropbox/AspireThemes/Themes/Ghost/$THEME_NAME/$THEME_NAME\ $THEME_VERSION

zip -r $THEME_NAME.zip $THEME_NAME

echo '===>>'
echo '===>> You Are Ready to Submit to Themeforest 👏👏👏'
echo '===>> Please Go Submit to Themeforest and Comeback and Hit ENTER 🔑  To Update Theme Docs & 🚀 to GitHub!'

python -mwebbrowser https://themeforest.net/user/aspirethemes/portfolio


##============================================
# Update Theme Docs Version and Push to Github
##============================================

read
echo 'Now We Are Going to Update Theme Docs and Push to Github 🚀 🚀 🚀'

ASPIRETHEMES_DIR=$HOME/www/aspirethemes
ASPIRETHEMES_DOCS_DIR=$HOME/www/aspirethemes/_docs
THEME_DOC_FILE=$ASPIRETHEMES_DOCS_DIR/$THEME.md

CURRENT_VERSION="Current Version:"
NEW_VERSION="Current Version: $THEME_VERSION - $(date +'%d %B %Y')"

perl -pi -e "s/$CURRENT_VERSION\s.*$/$NEW_VERSION/g" $THEME_DOC_FILE

echo '===>> Updated the Docs 👍👍'

git -C $ASPIRETHEMES_DIR commit -am "Updated $THEME current version to: $THEME_VERSION"
git -C $ASPIRETHEMES_DIR push

echo '===>> Pushed to GitHub 👍👍'
# echo '===>> You are ready to push the theme to the server, you can now hit 🔑  to push changes to the server 👏👏👏'


##============================================
# Push Theme to the Remote Server
##============================================

# read
# echo '===>> Now We Are Going to Push to the Server 🚀🚀'

# scp $THEME_NAME.zip root@$WORDPRESS_IP_ADDRESS:$WORDPRESS_REMOTE_THEMES_DIR
# echo '===>> Pushed to the server 🚀'

# ssh -t -t root@$WORDPRESS_IP_ADDRESS << EOT

# cd $WORDPRESS_REMOTE_THEMES_DIR
# echo $THEME_NAME
# rm -rf $THEME_NAME
# echo "===>> Removed $THEME_NAME"

# unzip -o $THEME_NAME.zip
# echo '===>> Un Zipped'

# rm -rf $THEME_NAME.zip
# echo "===>> Removed $THEME_NAME.zip"
# echo '===>> Done 👍'

# exit 1

# EOT