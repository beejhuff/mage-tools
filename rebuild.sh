#!/bin/bash

#create merged composer.json
mv composer.json composer-merge.json
mv magentocomposer/composer.json magentocomposer/composer-merge.json

./bin/jq -s '[.[] | to_entries] | flatten | reduce .[] as $dot ({}; .[$dot.key] += $dot.value)' ./magentocomposer/composer-merge.json ./composer-merge.json  > ./magentocomposer/composer.json

sudo mv http http-old
sudo rm -rf http-old
mkdir -p http

#sudo mv magentocomposer/vendor magentocomposer/vendor-old
#sudo rm -rf magentocomposer/vendor-old

#sudo rm -f magentocomposer/composer.lock

cd magentocomposer

echo "Run composer update?  (only if your packages have changed, takes a long time!)"
read -p "Are you sure? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  rm -rfv vendor
  rm -rfv bin
  rm composer.lock
  composer update
fi

composer install

cd ..
cd http
sudo rm -rfv media
sudo ln -s ../media/media .
sudo mkdir var/log
sudo chmod -R 777 var
sudo cp ../magentodocker/php/local.xml app/etc
cd ..

mv magentocomposer/vendor/composer/ http/

mv composer-merge.json composer.json
mv magentocomposer/composer-merge.json magentocomposer/composer.json
