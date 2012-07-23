#!/bin/sh

echo 'Updating Blog'
cd /home/developer/blog/application/trunk
git co master
git pull -u
echo 'Updating Presentation'
cd /home/developer/presentation/application/trunk
git co master
git pull -u
echo 'Updating Template Manager'
cd /home/developer/template_manager
git co master
git pull -u
echo 'Updating Image Manager'
cd /home/developer/image_manager
git co master
git pull -u
echo 'Updating Sitemap'
cd /home/developer/sitemap/application/trunk
git co master
git pull -u
echo 'Updating Callback'
cd /home/developer/callback/application/trunk
git co master
git pull -u
echo 'Updating Shared'
cd /home/developer/shared
git co master
git pull -u
echo 'Updating Systems'
cd /home/developer/systems
git co master
git pull -u

