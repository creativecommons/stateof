#!/bin/bash
set -o errtrace
set -o nounset


function _change_to_repo_dir {
    cd "${0%/*}/.." >/dev/null
}


function _prep {
    printf "\e[1m\e[7m %-80s\e[0m\n" 'Preparing to State of the Commons'
    if [[ -d temp_download ]]
    then
        # Remove modified HTML files to prevent issues with --continue
        find temp_download -name '*.html' -delete
        mv temp_download stateof.creativecommons.org
    fi
}


function _mirror {
    # Note: the --mirror option is equivalent to:
    #   --recursive
    #   --timestamping
    #   --level=inf
    #   --no-remove-listing
    wget \
        --adjust-extension \
        --backup-converted \
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


function _2017_root {
    printf "\e[1m\e[7m %-80s\e[0m\n" 'Mirroring 2017 State of the Commons'
    # Mirror
    _mirror /
    echo
}


function _2016_subdir {
    printf "\e[1m\e[7m %-80s\e[0m\n" 'Mirroring 2016 State of the Commons'
    # Mirror
    _mirror /2016/
    echo
}


function _2015_subdir {
    printf "\e[1m\e[7m %-80s\e[0m\n" 'Mirroring 2015 State of the Commons'
    # Mirror
    _mirror /2015/
    echo
}


function _fetch_missing_files {
    printf "\e[1m\e[7m %-80s\e[0m\n" 'Fetching missing files'
    local _dom='stateof.creativecommons.org'

    local _dir='/wp-content/uploads/2018/04/'
    local _file='arrow_down_blk.svg'
    mkdir -p "${_dom}/${_dir}"
    wget --continue -O ${_dom}${_dir}${_file} "https://${_dom}${_dir}${_file}"

    local _dir='/wp-includes/js/'
    local _file='wp-emoji-release.min.js'
    mkdir -p "${_dom}/${_dir}"
    wget --continue -O ${_dom}${_dir}${_file} "https://${_dom}${_dir}${_file}"

    local _dir='/2016/wp-includes/js/'
    local _file='wp-emoji-release.min.js'
    mkdir -p "${_dom}/${_dir}"
    wget --continue -O ${_dom}${_dir}${_file} "https://${_dom}${_dir}${_file}"

    local _d='/2016/wp-content/plugins/revslider/public/assets/js/extensions/'
    local _dir="${_d}"
    mkdir -p "${_dom}/${_dir}"
    for _file in \
        'revolution.extension.slideanims.min.js' \
        'revolution.extension.actions.min.js' \
        'revolution.extension.layeranimation.min.js' \
        'revolution.extension.parallax.min.js'
    do
        wget --continue -O ${_dom}${_dir}${_file} \
            "https://${_dom}${_dir}${_file}"
    done
}


function _cleanup {
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


_change_to_repo_dir  # must be called first
_prep
_2017_root
_2016_subdir
_2015_subdir
_fetch_missing_files
_cleanup
