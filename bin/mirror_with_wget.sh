#!/bin/bash
set -o errtrace
set -o nounset


BASE="${0%/*}"


_mirror(){
    # Note: the --mirror option is equivalent to:
    #   --recursive
    #   --timestamping
    #   --level=inf
    #   --no-remove-listing
    wget \
        --adjust-extension \
        --continue \
        --convert-links \
        --exclude-directories=${1}comments,${1}feed,${1}wp-json \
        --execute robots=off \
        --mirror \
        --no-cookies \
        --no-parent \
        --page-requisites \
        --reject 'xmlrpc.php*,wlwmanifest.xml' \
        "https://stateof.creativecommons.org${1}"
}


prep() {
    printf "\e[1m\e[7m %-80s\e[0m\n" 'Preparing to State of the Commons'
    if [[ -d docs ]]
    then
        # Remove HTML files to prevent issues with --continue
        find docs -name '*.html' -delete
        mv docs stateof.creativecommons.org
    fi
}


_2017_root() {
    printf "\e[1m\e[7m %-80s\e[0m\n" 'Mirroring 2017 State of the Commons'
    # Mirror
    _mirror /
    echo
}


_2016_subdir() {
    printf "\e[1m\e[7m %-80s\e[0m\n" 'Mirroring 2016 State of the Commons'
    # Mirror
    _mirror /2016/
    echo
}


_cleanup() {
    printf "\e[1m\e[7m %-80s\e[0m\n" 'Performing clean-up on mirror'
    if [[ -d stateof.creativecommons.org ]]
    then
        mv stateof.creativecommons.org docs
    else
        exit
    fi
    # Remove any empty directories
    find docs -type d -empty -delete
    echo 'Final size:'
    du -sh docs
    echo
}


cd "${BASE}/.." >/dev/null

_prep
_2017_root
_2016_subdir
_cleanup
