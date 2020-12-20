#!/bin/bash
set -euo pipefail
shopt -s inherit_errexit

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
source "$SCRIPTPATH/globals.sh"

assert_jekyll_not_running()
{
	set +e
	ps -a -o pid,cmd|grep jekyll|grep -v grep
	if [[ $? == 0 ]]; then
		echo "A copy of jekyll is already running (possibly via ./serve.h). Stop it and then re-run this script."
		exit 1
	fi
	set -e
}

install_required() {
	set +e
	sudo apt-get -y install ruby-dev libxml2-utils tidy
	set -e
}

build() {
	echo Building...

	pushd site
	bundle exec jekyll clean
	JEKYLL_ENV=production bundle exec jekyll build
	popd

	./update-mathjax.sh
}

validate_xml() {
	echo Validating XML Syntax...
	find site/_site -name '*.xml' -print0 | xargs -0 xmllint --noout

	echo "Validating sitemap against schema..."
	xmllint --noout --schema schemas/sitemap.xsd site/_site/sitemap.xml
}

validate_rss() {
	echo TODO Validating ATOM RSS...
	# xmllint --noout --schema schemas/atom.xsd site/_site/feed.rss
}

validate_html() {
	echo Validating HTML...

	set +e
	for file in $(find site/_site/ -name '*.html'); do
		tidy -errors -quiet $file
		if [[ $? != 0 ]]; then
			echo HTML validation failure in $file
			exit 1
		fi
	done
	set -e
}

validate_jsonld() {
	echo TODO: Validating JSON-LD...
}

validate_css() {
	echo TODO: Validating CSS...
}

validate_all() {
	validate_xml
	# RSS validation disabled due to error about not being deterministic.
	validate_rss
	validate_html
	validate_jsonld
	validate_css
}

executeScriptRemotely() {
	local NAME=$1
	shift
	local USER=$1
	shift
	local SCRIPT=$1
	shift

	local REMOTE_SCRIPT="/tmp/REMOTE_SCRIPT-$(uuidgen).sh"

	echo Copying $SCRIPT to $NAME:$REMOTE_SCRIPT
	gcloud compute scp $SCRIPT $NAME:$REMOTE_SCRIPT

	echo Running $REMOTE_SCRIPT on $NAME
	gcloud compute ssh $NAME --command "sudo -u $USER /bin/bash $REMOTE_SCRIPT"

	echo Removing $REMOTE_SCRIPT from $NAME
	gcloud compute ssh $NAME --command "rm $REMOTE_SCRIPT"
}

deploy() {
	local TARGET="/var/www/$HOSTNAME"

	local ID=$(uuidgen)
	local NEW="$TARGET-$ID"
	local OLD="$TARGET-OLD-$ID"
	local TARBALL=/tmp/deploy-$ID.tgz
	local DEPLOYMENT_SCRIPT="/tmp/deployment-$ID"

	cat > $DEPLOYMENT_SCRIPT <<-EOF
	set -euo pipefail
	shopt -s inherit_errexit

	umask 022
	mkdir $NEW
	cd $NEW
	tar xfz $TARBALL --no-same-owner --no-same-permissions
	rm $TARBALL

	if [[ -e $TARGET ]]; then
		mv $TARGET $OLD
	fi

	mv $NEW $TARGET

	if [[ -e $OLD ]]; then
		rm -r $OLD
	fi
	EOF

	# Put in a tarball because the scp command is much faster with a single large file than many small ones.
	tar cfz $TARBALL -C "$SCRIPTPATH/site/_site/" .
	gcloud compute scp $TARBALL $INSTANCE_NAME:$TARBALL
	rm $TARBALL

	executeScriptRemotely $INSTANCE_NAME root $DEPLOYMENT_SCRIPT
}

deadlink_check() {
	# Dead link checking has to happen after site is live.
	echo "Dead link checking..."
	SITE="https://$HOSTNAME"

	set +e
	./deadlink_check.sh "$SITE"
	if [[ $? != 0 ]]; then
		echo Dead link check failed
		exit 1
	fi
	set -e
}

google_request_reindex() {
	echo "Telling Google to check out the sitemap again..."
	curl "https://google.com/ping?sitemap=$SITE/sitemap.xml"
	# Make sure there's a new line after the curl.
	echo ""
}

trapABRT() {
	echo Trapped ABRT. SCRIPT DID NOT COMPLETE.
}

trapTERM() {
	echo Trapped TERM. SCRIPT DID NOT COMPLETE.
}

trapEXIT() {
	echo Trapped EXIT. SCRIPT DID NOT COMPLETE.
}

main() {
	trap trapABRT ABRT
	trap trapTERM TERM
	trap trapEXIT EXIT

	install_required

	assert_jekyll_not_running
	build
	validate_all
	deploy
	deadlink_check
	google_request_reindex

	trap - ABRT TERM EXIT
	echo OK. deploy.sh script completed successfully.
}

main

