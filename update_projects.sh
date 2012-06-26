#!/bin/sh

cd /home/developer/blog/application/trunk
git co master
git pull
cd /home/developer/presentation/application/trunk
git co master
git pull
cd /home/developer/sitemap/application/trunk
git co master
git pull
cd /home/developer/callback/application/trunk
git co master
git pull
cd /home/developer/template_manager
git co master
git pull
cd /home/developer/image_manager
git co master
git pull
cd /home/developer/shared
git co master
git pull

