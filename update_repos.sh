#!/bin/sh

echo 'Updating Blog'
cd /Users/mlintern/dev/blog/application/trunk
git co master
git pull -u

echo '\nUpdating Padrino'
cd /Users/mlintern/dev/padrino_api
git co master
git pull -u

echo '\nUpdating Image Manager'
cd /Users/mlintern/dev/image_manager
git co master
git pull -u

echo '\nUpdating Sitemap'
cd /Users/mlintern/dev/sitemap
git co master
git pull -u

echo '\nUpdating Shared'
cd /Users/mlintern/dev/shared
git co master
git pull -u

echo '\nUpdating Systems'
cd /Users/mlintern/dev/systems
git co master
git pull -u

echo '\nUpdating Presentation'
cd /Users/mlintern/dev/presentation/application/trunk
git co master
git pull -u

echo '\nUpdating Callback'
cd /Users/mlintern/dev/callback/application/trunk
git co master
git pull -u