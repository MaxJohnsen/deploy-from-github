BRANCH="master"
SITE_NAME="example.site.com"
APP_POOL="example.pool"
SOURCE_CODE="/c/src/example.site.com"
PUBLISH_OUTPUT="c:\www\example.site.com"

cd "${SOURCE_CODE}"
git checkout ${BRANCH}
git fetch
HEADHASH=$(git rev-parse HEAD)
UPSTREAMHASH=$(git rev-parse  ${BRANCH}@{upstream})

if [ "$UPSTREAMHASH" == "" ]
then
	echo -e ${ERROR}Could not find upstream hash. Aborting.
	exit 1
fi

if [ "$HEADHASH" != "$UPSTREAMHASH" ]
then
	echo -e Changes detected, starting deployment procedure..
	echo -e Pull new changes..
	git pull
	echo -e Stopp website: ${SITE_NAME}
	appcmd stop sites "${SITE_NAME}"
	echo -e Stopp AppPool: ${APP_POOL}
	appcmd stop apppool /apppool.name:"${APPP_OOL}"
	echo -e Publish new version to ${PUBLISH_OUTPUT}..
	dotnet publish -c Release -o "${PUBLISH_OUTPUT}"
	echo -e Start AppPool: ${APP_POOL}
	appcmd start apppool /apppool.name:"${APP_POOL}"
	echo -e Start website: ${SITE_NAME}..
	appcmd start sites "${SITE_NAME}"
	echo -e ${FINISHED}Deployment complete.${NOCOLOR}
else
	echo -e ${FINISHED}No changes detected.${NOCOLOR}
fi
exit 0
