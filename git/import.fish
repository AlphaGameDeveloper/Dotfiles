#!/bin/bash

function load_file
	source $HOME/.dotfiles/git/$1
end

# call load_file
load_file identity.sh
load_file config.sh
load_file alias.sh
