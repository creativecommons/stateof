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
    if [[ -d temp_download ]]
    then
        # Remove modified HTML files to prevent issues with --continue
        find temp_download -name '*.html' -delete
        mv temp_download stateof.creativecommons.org
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


_2015_subdir() {
    printf "\e[1m\e[7m %-80s\e[0m\n" 'Mirroring 2015 State of the Commons'
    # Mirror
    _mirror /2015/
    echo
}


_cleanup() {
    printf "\e[1m\e[7m %-80s\e[0m\n" 'Performing clean-up on mirror'
    if [[ -d stateof.creativecommons.org ]]
    then
        mv stateof.creativecommons.org temp_download
    else
        exit
    fi
    # Remove any empty directories
    find temp_download -type d -empty -delete
    echo 'Final size:'
    du -sh temp_download
    echo
}


cd "${BASE}/.." >/dev/null

_prep
_2017_root
_2016_subdir
_2015_subdir
_cleanup
