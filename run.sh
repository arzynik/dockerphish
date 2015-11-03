#!/bin/bash
if [ "$#" -eq 0 ]; then
	echo "No command/process type specified"
        exit 1
fi

if [ ! -d "/app" ]; then
	if [ -n "$GIT_REPO" ]; then
		if [ -n "$GIT_BRANCH" ]; then
			git clone --single-branch --depth 1 -b "$GIT_BRANCH" "$GIT_REPO" /app
		else
			echo "No \$GIT_BRANCH environment variable defined, assuming MASTER"
			git clone --single-branch --depth 1 "$GIT_REPO" /app
		fi
	else
		echo "No \$GIT_REPO environment variable defined"
		exit 1
	fi
fi

nginx && php-fpm
