#/bin/sh


start_dir='/Users/mlintern/dev/'
dir_list=('blog/application/trunk' 'padrino_api' 'systems' 'callback/application/trunk' 'sitemap' 'content_router' 'shared' 'gettington' 'ProductSupport' 'Website' 'kanhub' 'presentation/application/trunk' 'hubot' 'wordpress-import' 'image_manager' 'BlueLantern' 'maeby' 'analytics-collector' 'analytics-processor' 'cpdm-es-plugins' 'WordpressIntegration' 'ContentGrader' 'CompendiumOSN' 'osn-notifiier' 'Selenium Tests' 'rss-fetcher-cpdm' 'MetaConfigProxy' 'LocalProxy' 'yard-compendium')

for i in "${dir_list[@]}"
do
	dir=$start_dir$i
	printf "\n\n\n"
	echo $dir
	cd $dir
	git checkout master
	git fetch origin
	git push --all orahub
done

