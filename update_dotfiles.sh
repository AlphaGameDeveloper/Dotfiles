#!/usr/bin/env bash
#	MIT License

#	Copyright (c) 2024 Damien Boisvert

#	Permission is hereby granted, free of charge, to any person obtaining a copy
#	of this software and associated documentation files (the "Software"), to deal
#	in the Software without restriction, including without limitation the rights
#	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#	copies of the Software, and to permit persons to whom the Software is
#	furnished to do so, subject to the following conditions:

#	The above copyright notice and this permission notice shall be included in all
#	copies or substantial portions of the Software.

#	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#	SOFTWARE.

set -e

function update_failure {
	echo "$p Dotfiles failed to update!"
	echo "$p Specifically, '$*' failed."
	echo "$p Error information can be found at:"
	echo "$p 	$ADF_GITPULL_OUTPUT_FILE"
	exit 1
}

if test -n "$BASH" ; then script=$BASH_SOURCE
elif test -n "$TMOUT"; then script=${.sh.file}
elif test -n "$ZSH_NAME" ; then script=${(%):-%x}
elif test ${0##*/} = dash; then x=$(lsof -p $$ -Fn0 | tail -1); script=${x#n}
else script=$0
fi

PRE_PWD=$(pwd)
SCRIPT_DIR=$(dirname $script)

cd $SCRIPT_DIR
# we get the original git commit to see if it updated
ORIGINAL_COMMIT=$(git log --format="%H" -n 1)

# if linux
if [ "$(uname)" = "Linux" ]; then
	ADF_GITPULL_OUTPUT_FILE=$(mktemp -t alphadotfiles.XXXXXX)
elif [ "$(uname)" = "Darwin" ]; then
	ADF_GITPULL_OUTPUT_FILE=$(mktemp -t alphadotfiles)
fi

# use the github rest api to get the latest commit id
# and compare it to the current commit id
# if the commit id is different, then we need to update
NEW_COMMIT=$(curl -s -H "Accept: application/vnd.github.v3+json" \
	"https://api.github.com/repos/AlphaGameDeveloper/Dotfiles/commits/master" | \
	jq -r '.sha')

if [ "$ORIGINAL_COMMIT" != "$NEW_COMMIT" ]; then	
	echo $NEW_COMMIT
	git pull > $ADF_GITPULL_OUTPUT_FILE 2> $ADF_GITPULL_OUTPUT_FILE || update_failure git pull
fi

if [ "$ADF_KEEP_OLD_GITPULL_FILES" -eq "" ]; then
	rm $ADF_GITPULL_OUTPUT_FILE
fi

if [ "$ORIGINAL_COMMIT" != "$NEW_COMMIT" ]; then
	NEW_COMMIT_MSG=$(git log -1 --pretty=%B $NEW_COMMIT)
	
	echo "$p Dotfiles have been updated. ($NEW_COMMIT)"
	echo "$p You should restart your shell session, or reload the dotfiles with"
 	echo "$p source ~/.zshrc (or wherever you store the file!)"
	exit 0
fi	
