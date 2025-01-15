#!/usr/bin/env bash -xeuo pipefail
#	MIT License

#	Copyright (c) 2025 Damien Boisvert

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

command -v curl > /dev/null || (echo "curl is not installed. Please install it." && exit 1)
command -v unzip > /dev/null || (echo "unzip is not installed. Please install it." && exit 1)

FONT_ZIP_LOCATION="/tmp/jetbrains-mono-font.zip"
FONT_TEMPORARY_UNZIPPED_LOCATION="/tmp/jetbrains-mono-font"
FONT_LIBRARY_FINAL_LOCATION="$HOME/Library/Fonts/JetBrains-Mono"

mkdir -p $FONT_LIBRARY_FINAL_LOCATION
curl -o $FONT_ZIP_LOCATION -L https://download.jetbrains.com/fonts/JetBrainsMono-2.304.zip -q
unzip -o $FONT_ZIP_LOCATION -d $FONT_TEMPORARY_UNZIPPED_LOCATION
rm $FONT_ZIP_LOCATION

if [ "$1" -eq "macos" ]; then
	cp $FONT_TEMPORARY_UNZIPPED_LOCATION/fonts/ttf/*.ttf $FONT_LIBRARY_FINAL_LOCATION
else
	echo "Font files installed at $FONT_TEMPORARY_UNZIPPED_LOCATION."
	exit 0
fi

# Cleaning up!
rm -rf $FONT_TEMPORARY_UNZIPPED_LOCATION
echo "JetBrains Mono font installed successfully!"
