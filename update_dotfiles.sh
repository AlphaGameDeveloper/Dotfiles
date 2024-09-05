#!/usr/bin/env bash -x
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
}
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
p="update_dotfiles.sh:"
cd $SCRIPT_DIR
# we get the original git commit to see if it updated
ORIGINAL_COMMIT=$(git log --format="%H" -n 1)

git pull > $SCRIPT_DIR/update_result || update_failure git pull
date >> $SCRIPT_DIR/update_result

NEW_COMMIT=$(git log --format="%H" -n 1)

if [ "$ORIGINAL_COMMIT" != "$NEW_COMMIT" ]; then
	NEW_COMMIT_MSG=$(git log -1 --pretty=%B $NEW_COMMIT)
	
	echo "$p Dotfiles have been updated."
	echo "$p ----> Previous commit: $ORIGINAL_COMMIT"
	echo "$p ----> New      commit: $NEW_COMMIT"
	echo "$p ----> Commit  message: $NEW_COMMIT_MSG"
fi	
