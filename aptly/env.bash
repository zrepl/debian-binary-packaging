realaptly="$(which --skip-alias aptly)"
zrepl_aptly_wrapper() {
    # sanity check
    if [ ! -f "aptly.conf" ]; then
        echo "aptly wrapper: sanity check failed: aplty.conf not found, change to apty directory"
        return 1
    else
        local args=("$@")
        GNUPGHOME="$(readlink -f repo-gpghome)" "$realaptly" --config aptly.conf "${args[@]}"
    fi
}
alias aptly=zrepl_aptly_wrapper

