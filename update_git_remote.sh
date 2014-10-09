#/bin/sh


start_dir='/Users/mlintern/dev/'
dir_list=('blog/application/trunk' 'padrino_api' 'systems' 'callback/application/trunk' 'sitemap' 'content_router' 'shared' 'gettington' )

for i in "${dir_list[@]}"
do
	dir=$start_dir$i
	echo $dir
	cd $dir
	git checkout master
	git fetch origin
	git push --all orahub
done

