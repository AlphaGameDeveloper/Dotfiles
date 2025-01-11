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

curl -o /tmp/jetbrains-mono.zip -L https://download.jetbrains.com/fonts/JetBrainsMono-2.304.zip -q
unzip -o /tmp/jetbrains-mono.zip -d /tmp/jetbrains-mono-font
cp /tmp/jetbrains-mono-font/fonts/ttf/*.ttf ~/Library/Fonts