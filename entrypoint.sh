#!/usr/bin/env bash
set -e

function die()
{
    echo "::error::$1"
    echo "------------------------------------------------------------------------------------------------------------------------"
    exit 1
}

cat << END
------------------------------------------------------------------------------------------------------------------------
                                                            _ _ _       _   
                                                           (_) (_)     | |  
                                              ___ _ __ ___  _| |_ _ __ | |_ 
                                             / __| '_ \` _ \| | | | '_ \| __|
                                             \__ \ | | | | | | | | | | | |_ 
                                             |___/_| |_| |_|_|_|_|_| |_|\__|
 
                             https://github.com/hacking-actions/smilint (c) 2019 Max Hacking
------------------------------------------------------------------------------------------------------------------------
END

# Check for a GITHUB_WORKSPACE env variable
[[ -z "${GITHUB_WORKSPACE}" ]] && die "Must set GITHUB_WORKSPACE in env"
cd "${GITHUB_WORKSPACE}" || die "GITHUB_WORKSPACE does not exist"

exitval=0

warning_level=${INPUT_WARNING_LEVEL:-4}

while IFS= read -r -d '' f
do
    if [[ "$(mimetype -b "${f}")" == "text/plain" ]]; then
        if (( $(smiquery module "${f}" | wc -l) > 4 )); then
            echo "Checking ${f}"
            if (( $(smilint -s --level="${warning_level}" "${f}" 2>&1 | wc -l) > 0 )); then
                exitval=1
                smilint -s --level="${warning_level}" "${f}" 2>&1
                echo
            fi
        fi
    fi
done <   <(find . -type f ! -iname ".*" ! -path "./.*" -print0)

echo "------------------------------------------------------------------------------------------------------------------------"
exit ${exitval}
