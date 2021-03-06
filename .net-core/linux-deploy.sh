BRANCH="master"
SERVICE_USER="example_user"
SERVICE_NAME="example.site.com"
SOURCE_CODE="/home/${SERVICE_USER}/sites/src/example.site.com"
PUBLISH_OUTPUT="/home/${SERVICE_USER}/sites/www/example.site.com"
DOTNET_DIR="/usr/local/bin"
AUTOMATIC_MIGRATIONS=true
ASPNETCORE_ENVIRONMENT="Production"

cd "${SOURCE_CODE}"
sudo -u ${SERVICE_USER} git checkout ${BRANCH}
sudo -u ${SERVICE_USER} git fetch
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
	sudo -u ${SERVICE_USER} git pull
	echo -e Stopp service ${SERVICE_NAME}..
	systemctl stop ${SERVICE_NAME}
	echo -e Publish new version to ${PUBLISH_OUTPUT}..
	export ASPNETCORE_ENVIRONMENT=${ASPNETCORE_ENVIRONMENT}
	sudo -u ${SERVICE_USER} -E ${DOTNET_DIR}/dotnet publish -c Release -o "${PUBLISH_OUTPUT}"
	if [ $AUTOMATIC_MIGRATIONS ]
	then
		echo -e Check for new database migrations..
		sudo -u ${SERVICE_USER} -E ${DOTNET_DIR}/dotnet ef database update
	fi
	echo -e Start service ${SERVICE_NAME}..
	systemctl start ${SERVICE_NAME}
	echo -e ${FINISHED}Deployment complete.${NOCOLOR}
else
	echo -e ${FINISHED}No changes detected.${NOCOLOR}
fi
exit 0
