#!/bin/sh
#
# This take two parameters.
#
# ~> sh rc_cleanup.sh <service> <ticket number>
#
# Allowed Services: blog, pres, call 

SERVICE=$1
TICKET=$2

if [ ${SERVICE} == "blog" ]; then
	for i in $(svn list https://redmine.eng.compendiumblog.com/svn/blog/application/tags | grep "\-RC"); do
		svn rm -m "RC Cleanup (${i}), refs #${TICKET}" https://redmine.eng.compendiumblog.com/svn/blog/application/tags/${i}
	done
elif [ ${SERVICE} == "pres" ]; then
	for i in $(svn list https://redmine.eng.compendiumblog.com/svn/presentation/application/tags | grep "\-RC"); do
		svn rm -m "RC Cleanup (${i}), refs #${TICKET}" https://redmine.eng.compendiumblog.com/svn/presentation/application/tags/${i}
	done
elif [ ${SERVICE} == "call" ]; then
	for i in $(svn list https://redmine.eng.compendiumblog.com/svn/callback/application/tags | grep "\-RC"); do
		svn rm -m "RC Cleanup (${i}), refs #${TICKET}" https://redmine.eng.compendiumblog.com/svn/callback/application/tags/${i}
	done
fi