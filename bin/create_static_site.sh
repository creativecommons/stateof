#!/bin/bash
set -o errexit
set -o errtrace
set -o nounset


if command -v gsed >/dev/null
then
    SED=gsed
elif sed --version >/dev/null
then
    SED=sed
else
    echo 'GNU sed is required. If on macOS install `gnu-sed` via brew.' 1>&2
    exit 1
fi


function _change_to_repo_dir {
    cd "${0%/*}/.." >/dev/null
}


function _wipe_and_recreate_docs_dir {
    printf "\e[1m\e[7m %-80s\e[0m\n" 'Wipe and recreate docs/ directory'
    rm -rf docs/*
    cp -a temp_download/* docs/
    touch docs/.nojekyll
    printf 'dev-stateof.creativecommons.org' > docs/CNAME
    echo
}


function _remove_deprecated_links_meta_scripts_from_html_files {
    printf "\e[1m\e[7m %-80s\e[0m\n" \
        'Remove deprected links, meta, and scripts from HTML files'
    for _file in $(find docs -type f -name '*.html')
    do
        #  1. Remove link: WordPress Edit URI
        #  2. Remove link: WordPress JSON API
        #  3. Remove link: WordPress RSS
        #  4. Remove link: WordPress shortlink
        #  5. Remove link: WordPress v0 prefetch
        #  6. Remove link: WordPress Windows Live Writer Manifest link
        #  7. Remove meta: generator
        #  8. Remove meta: generator at end of line
        #  9. Remove script: JetPack scripts
        # 10. Remove script: WordPress stats
        # 11. Remove script: WordPress Admin AJAX
        ${SED} \
            -e'/^<link rel="EditURI"/d' \
            -e'/^<link .*\/wp-json\//d' \
            -e'/^<link .*type="application\/rss+xml"/d' \
            -e"/^<link rel='shortlink'/d" \
            -e'/^<link .*v0\.wordpress\.com/d' \
            -e'/^<link rel="wlwmanifest"/d' \
            -e'/^<meta name="generator"/d' \
            -e's#<meta name="generator".*$##' \
            -e'/^<script .*jetpack.*<\/script>$/d' \
            -e'/^<script .*stats\.wp\.com.*<\/script>$/d' \
            -e's#^<script .*/2016/wp-admin/admin-ajax\.php"</script>##' \
            --in-place "${_file}"
    done
    for _file in $(find docs/2015 -type f -name '*.html')
    do
        # 1. Remove (no)script: stats.creativecommons.org
        ${SED} --null-data \
            -e's#<script [^\n]*stats\.creativecommons\.org.*</noscript>\n##' \
            --in-place "${_file}"
    done
    echo
}


function _restore_query_strings_in_html_files {
    printf "\e[1m\e[7m %-80s\e[0m\n" 'Restore query strings in HTML files'
    for _file in $(find docs -type f -name '*.html')
    do
        # 1. Restore CSS query strings
        # 2. Restore JavaScript query strings
        # 3. Restore TTF query strings
        # 4. Restore woff/woff2 query strings
        # 5. Restore style_dynamic.php query strings
        # 6. Restore style_dynamic_responsive.php query strings
        ${SED} --regexp-extended \
            -e's#(\.css)%3F(ver=)#\1?\2#g' \
            -e's#(\.js)%3F(ver=)#\1?\2#g' \
            -e's#(\.ttf)%3F#\1?#g' \
            -e's#(\.woff2+)%3F#\1?#g' \
            -e's#(style_dynamic\.php)%3F#\1.css?#g' \
            -e's#(style_dynamic_responsive\.php)%3F#\1.css?#g' \
            --in-place "${_file}"
    done
    echo
}


function _update_licensebuttons_domain {
    printf "\e[1m\e[7m %-80s\e[0m\n" 'Update licensebuttons domain'
    for _file in $(find docs/2015 -type f -name '*.html')
    do
        ${SED} \
            -e's#//i\.creativecommons\.org/#//licensebuttons.net/#g' \
            --in-place "${_file}"
    done
    echo
}


function _fix_2017_social_media_links {
    printf "\e[1m\e[7m %-80s\e[0m\n" 'Fix 2017 Social Media links'
    for _file in $(find docs -maxdepth 1 -type f -name '*.html')
    do
        ${SED} --regexp-extended \
            -e's#^(<a.*elementor-social-icon-facebook" href=")[^"]+(" target="_blank">)#\1https://www.facebook.com/creativecommons\2#g' \
            -e's#^(<a.*elementor-social-icon-twitter" href=")[^"]+(" target="_blank">)#\1https://twitter.com/creativecommons\2#g' \
            --in-place "${_file}"
    done
    echo
}


function _remove_2016_unused_files {
    printf "\e[1m\e[7m %-80s\e[0m\n" 'Remove 2016 unused files'
    rm -rf docs/2016/negara-commons-2017-2
    rm -rf docs/2016/стан-коммонс-2016-року
    echo
}


function _remove_2016_broken_newsletter_form {
    printf "\e[1m\e[7m %-80s\e[0m\n" 'Remove 2016 broken newsletter form'
    for _file in $(find docs/2016 -type f -name '*.html')
    do
        ${SED} --null-data \
            -e's#<div id="deed-donate-slide".*</form>\n</div>\n</div>\n</div>\n</div>\n##' \
            -e's#<script[^\n]*\n\n  function isScrolledIntoView.*&gt;\n</script>\n##' \
            --in-place "${_file}"
    done
    echo
}


function _fix_2015_twitter_links {
    printf "\e[1m\e[7m %-80s\e[0m\n" 'Fix 2015 Twitter links'
    ${SED} \
        -e's#^&lt;a href=.https://twitter\.com.*$#<a href="https://twitter.com/intent/tweet?source=webclient\&amp;text=State+of+the+Commons+stateof.creativecommons.org%2F2015%2F\&via=creativecommons"><img src="https://licensebuttons.net/gi/social-32-twitter.png" alt="">\&nbsp; Share on Twitter</a>#g' \
        --in-place docs/2015/index.html
    echo
}


function _remove_2015_broken_french_translation {
    printf "\e[1m\e[7m %-80s\e[0m\n" 'Remove 2015 broken French translation'
    ${SED} --regexp-extended \
        -e's#^(<li><a href="translation-xas\.csv\.html">Fre.*$)#<!-- \1 -->#' \
        --in-place docs/2015/index.html
    rm docs/2015/translation-xas.csv.html
    echo
}


function _remove_2015_broken_newsletter_form {
    printf "\e[1m\e[7m %-80s\e[0m\n" 'Remove 2015 broken newsletter form'
    ${SED} \
        -e'/^<form/d' \
        -e'/^<p class="text-center">.*Creative Commons newsletter/d' \
        -e'/^<p class="text-center"><input id="email-Primary"/d' \
        -e'/^<button class="btn btn-success" id="_qf_Edit_next"/d' \
        -e'/^<\/form>/d' \
        --in-place docs/2015/index.html
    echo
}


function _replace_full_urls_with_absolute_paths {
    printf "\e[1m\e[7m %-80s\e[0m\n" 'Replace full URLs with absolute paths'
    # Non-escaped URLs with protocol
    for _pattern in \
        'http://stateof\.creativecommons\.org/' \
        'https://stateof\.creativecommons\.org/'
    do
        for _file in $(grep --files-with-matches --max-count=1 \
            --recursive "${_pattern}" docs)
        do
            ${SED} -e"s#${_pattern}#/#g" --in-place "${_file}"
        done
    done
    # Non-escaped URLs without protocol
    _pattern='//stateof\.creativecommons\.org/'
    for _file in $(grep --files-with-matches --max-count=1 \
        --recursive "${_pattern}" docs)
    do
        ${SED} -e"s#${_pattern}#/#g" --in-place "${_file}"
    done
    # Escaped URL
    for _file in $(grep --fixed-strings --files-with-matches --max-count=1 \
        --recursive 'https:\/\/stateof.creativecommons.org\/' docs)
    do
        ${SED} \
            -e's#https:\\/\\/stateof\.creativecommons\.org\\/#\\/#g' \
            --in-place "${_file}"
    done
    echo
}


function _revert_non_html_conversions {
    printf "\e[1m\e[7m %-80s\e[0m\n" 'Revert non-HTML file conversions'
    for _file in $(find docs -type f -name '*\?*' -not -name 'index.html*' \
        -not -name 'low-bandwidth.html*' -not -name '*orig')
    do
        local _orig="${_file%????}orig"
        local _fixed="${_file%%\?*}"
        if [[ -f "${_orig}" ]]
        then
            # Restore original and remove query strings
            rm "${_file}"
            mv "${_orig}" "${_fixed}"
        else
            # Remove query strings
            mv "${_file}" "${_fixed}"
        fi
    done
    # Remove innaccurate .html file extension
    for _file in $(find docs -type f -name '*.woff2.html')
    do
        mv "${_file}" "${_file%.html}"
    done
    for _file in docs/2016/wp-content/themes/optimizewp/assets/css/*.php
    do
        mv ${_file} ${_file}.css
    done
    echo
}


function _cleanup_plaintext_whitespace {
    printf "\e[1m\e[7m %-80s\e[0m\n" 'Clean-up whitespace in plaintext files'
    # plaintext files with trailing whitespace
    for _file in $(find docs -type f \
        \( -name '*.css' -o -name '*.html' -o -name '*.js' \))
    do
        ${SED} -e's#[ \t]\+$##' --in-place "${_file}"
    done
    echo
}


function _cleanup_orig_file_backups {
    printf "\e[1m\e[7m %-80s\e[0m\n" 'Clean-up orig file backups'
    find docs -type f -name '*orig' -delete
}


_change_to_repo_dir  # must be called first
_wipe_and_recreate_docs_dir
_remove_deprecated_links_meta_scripts_from_html_files
_restore_query_strings_in_html_files
_update_licensebuttons_domain
_fix_2017_social_media_links
_remove_2016_unused_files
_remove_2016_broken_newsletter_form
_fix_2015_twitter_links
_remove_2015_broken_french_translation
_remove_2015_broken_newsletter_form
_replace_full_urls_with_absolute_paths
_revert_non_html_conversions
_cleanup_plaintext_whitespace
_cleanup_orig_file_backups
