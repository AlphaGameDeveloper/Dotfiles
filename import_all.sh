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


function load_file {
	source $SCRIPT_DIR/$1
}

if test -n "$BASH" ; then script=$BASH_SOURCE
elif test -n "$TMOUT"; then script=${.sh.file}
elif test -n "$ZSH_NAME" ; then script=${(%):-%x}
elif test ${0##*/} = dash; then x=$(lsof -p $$ -Fn0 | tail -1); script=${x#n}
else script=$0
fi


SCRIPT_DIR=$(dirname $script)

$SHELL $SCRIPT_DIR/update_dotfiles.sh
load_file exports.sh
load_file git/alias.sh
load_file git/config.sh
load_file git/identity.sh

# -- go back to where you came from! --
cd $PRE_PWD
