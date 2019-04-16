### bash-native/grep.sh Usage:bbuild
#
# A basic implementation of 'grep' functionality using native bash constructs.
#
###/doc

### native:grep PATTERN FILE Usage:bbuild
#
# Find regular expression PATTERN in FILE
#
###/doc
native:grep() {
    local dataline
    local pattern="$1"; shift
    local file="$1"; shift

    while read dataline; do
        if [[ "$dataline" =~ $pattern ]]; then
            echo "$dataline"
        fi
    done < "$file"
}
