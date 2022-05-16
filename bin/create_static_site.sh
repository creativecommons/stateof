#!/bin/bash
set -o errtrace
set -o nounset


if command -v gsed >/dev/null; then
    SED=gsed
elif sed --version >/dev/null; then
    SED=sed
else
    echo 'GNU sed is required. If on macOS install `gnu-sed` via brew.' 1>&2
    exit 1
fi


function _change_to_repo_dir {
    cd "${0%/*}/.." >/dev/null
}


function _recreate_docs_dir {
    rm -rf docs
    cp -a temp_download docs
    touch docs/.nojekyll
    printf 'stateof.creativecommons.org' > docs/CNAME
}


function _convert_urls_to_absolute_paths {
    # Non-escaped URLs
    for _pattern in 'http://stateof\.creativecommons\.org/' \
                    'https://stateof\.creativecommons\.org/'
    do
        for _file in $(grep --files-with-matches --max-count=1 \
            --recursive "${_pattern}" docs)
        do
            gsed --in-place -e"s#${_pattern}#/#g" "${_file}"
        done
    done
    # Escaped URL
    for _file in $(grep --fixed-strings --files-with-matches --max-count=1 \
        --recursive 'https:\/\/stateof.creativecommons.org\/' docs)
    do
        gsed --in-place \
            -e's#https:\\/\\/stateof\.creativecommons\.org\\/#\\/#g' "${_file}"
    done
}


_change_to_repo_dir  # must be called first
_recreate_docs_dir
_convert_urls_to_absolute_paths
