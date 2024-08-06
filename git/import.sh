#!/bin/bash

function load_file {
	source $HOME/.dotfiles/git/$1
}

# call load_file
load_file identity.sh
load_file config.sh
