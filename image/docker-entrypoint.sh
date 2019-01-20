#!/bin/bash

set -e

if [ ! -f /.dockerenv ]; then
	echo "$0 should only be run in Docker container" 1>&2
	exit 1
fi

username=${USERNAME:-keepassxc}
uid=${UID:-1000}
gid=${GID:-1000}

create_user() {
	if ! getent group "${username}" > /dev/null; then
		groupadd --force --gid "${gid}" "${username}"
	fi

	mkdir -p "/home/${username}"
	if ! getent passwd "${username}" > /dev/null; then
		useradd --uid "${uid}" --gid "${gid}" "${username}"
	fi

	chown "${username}:${username}" -R "/home/${username}"
}

launch_keepassxc() {
	cd "/home/${username}"
	exec sudo -HEu "${username}" QT_GRAPHICSSYSTEM=native "$@"
}

create_user

case "$1" in
	keepassxc)
		launch_keepassxc "$@"
		;;
	*)
		exec "$@"
		;;
esac
