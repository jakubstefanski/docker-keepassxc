#!/bin/bash

set -e

if [ ! -f /.dockerenv ]; then
	echo "$0 should only be run in Docker container" 1>&2
	exit 1
fi

user_name=${USER_NAME:-keepassxc}
user_uid=${USER_UID:-1000}
user_gid=${USER_GID:-1000}

create_user() {
	if ! getent group "${user_name}" > /dev/null; then
		groupadd --force --gid "${user_gid}" "${user_name}"
	fi

	if ! getent passwd "${user_name}" > /dev/null; then
		adduser --disabled-login --uid "${user_uid}" --gid "${user_gid}" \
			--gecos "${user_name}" "${user_name}"
	fi

	chown "${user_name}:${user_name}" -R "/home/${user_name}"
}

launch_keepassxc() {
	cd "/home/${user_name}"
	exec sudo -HEu "${user_name}" QT_GRAPHICSSYSTEM=native "$@"
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
