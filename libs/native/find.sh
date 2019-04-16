native:find() {
    local namepat
    local basedir="${1:-}"; shift || :

    [[ -n "$basedir" ]] || {
        echo "No basedir specified"
        return 1
    }

    local exec_array=(:)
    native:find:_extract_exec_array exec_array "$@"
    native:find:_extract_named_token namepat -name "$@"

    native:find:_recursive_find "$basedir" "$namepat" "${exec_array[@]}"
}

native:find:_recursive_find() {
    local path
    local basedir="$1"; shift
    local namepat="$1"; shift

    for path in "$basedir"/*; do
        if [[ ! -e "$path" ]]; then
            # glob did not expand
            return 1

        elif [[ -z "$namepat" ]]; then
            native:find:_exec_replace "$path" "$@"

        elif [[ "${path##*/}" == $namepat ]]; then # Uses glob matching
            native:find:_exec_replace "$path" "$@"
        fi

        if [[ -d "$path" ]]; then
            native:find:_recursive_find "$path" "$namepat" "$@"
        fi
    done
}

native:find:_exec_replace() {
    local path="$1"; shift
    local targetexec=(:)
    local arg

    for arg in "$@"; do
        if [[ "$arg" = '{}' ]]; then
            targetexec+=("$path")
        else
            targetexec+=("$arg")
        fi
    done

    "${targetexec[@]:1}"
}

native:find:_extract_exec_array() {
    declare -n p_exec_array="${1:-}"; shift
    p_exec_array=(: echo '{}')
    
    local in_def=false
    local arg

    for arg in "$@"; do
        if [[ "$in_def" = true ]]; then
            if [[ "$arg" = ';' ]]; then
                break
            else
                p_exec_array+=("$arg")
            fi
        else
            if [[ "$arg" = -exec ]]; then
                in_def=true
                p_exec_array=(:)
            fi
        fi
    done

    p_exec_array=("${p_exec_array[@]:1}")
}

native:find:_extract_named_token() {
    declare -n p_returnvar="$1"; shift
    local token_namer="$1"; shift
    local in_def=false
    local arg

    for arg in "$@"; do
        if [[ "$in_def" = true ]]; then
            p_returnvar="$arg"
            return
        else
            if [[ "$arg" = "$token_namer" ]]; then
                in_def=true
            fi
        fi
    done
}
