#!/usr/bin/env bbrun

#%include libs/native/find.sh
#%include libs/native/grep.sh
#%include std/out.sh

run_multiple() {
    for x in {1..20}; do
        "$@" >/dev/null
    done
}

out:info "Testing normal"
time run_multiple find "$1" -name '*.sh' -exec grep debug: {} \;

echo

out:info "Testing native"
time run_multiple native:find "$1" -name '*.sh' -exec native:grep debug: {} \;
