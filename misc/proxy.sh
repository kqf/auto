function enable-proxy {
    local withports=$(ps ax | grep cntlm | grep localhost)

    # Start the cntlm if no one has started yet
    [ -z "$withports" ] && rm -f ~/.cntlm-HI-Z0DEG.pid && cntlm-start


    local port=$(
        ps ax |
        grep cntlm |
        grep localhost |
        tail -n 1 |
        tr -s ' ' |
        cut -d' ' -f16
    )
    echo "An exposed port found ${port}. Exporting the variables ..."
    export http_proxy=http://localhost:${port}/
    export https_proxy=http://localhost:${port}/
    echo "Exported variables:"
    echo -e "\thttp_proxy=${http_proxy}"
    echo -e "\thttps_proxy=${https_proxy}"
    echo "Done."
}
