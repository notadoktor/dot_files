#!/bin/bash -e

# loop over a given ip range and check for a response, optionally in parallel

# usage: ping_range.sh <ip-range> <parallel>
# example: ping_range.sh

NPROC=$(nproc)
MAX_PROCS=$((NPROC - 1))
NUM_PROCS=1

ping_ip() {
    local ip="$1"
    if ping -c 1 -W 1 "$ip" &>/dev/null; then
        echo "$ip"
    fi
}

show_help() {
    cat <<EOF
Usage: ping_range.sh [-p] [-j <num-procs>] -r <ip-range>

Options:
    -p  ping with max available processes ($MAX_PROCS)
    -j  use specific number of processes (default: 1)
    -r  ip range to ping (required)
    -h  show this help message
EOF
    return 1
}

while getopts ':r:pj:h' opt; do
    case "$opt" in
        r)
            BASE_RANGE=$OPTARG
            ;;
        p)
            NUM_PROCS=$MAX_PROCS
            ;;
        j)
            NUM_PROCS=$OPTARG
            ;;
        h)
            show_help
            ;;
        :)
            echo "Error: -$OPTARG requires an argument."
            exit 1
            ;;
        *)
            echo "Unknown option: -$OPTARG"
            exit 1
            ;;
    esac
done

if [[ -z "$BASE_RANGE" ]]; then
    echo "Error: missing required argument: -r <ip-range>"
    exit 1
fi

NUM_CHECKED=1
PCNT=$(pcnt)
for i in {1..255}; do
    if ((NUM_CHECKED >= 255)); then
        break
    elif ((i == 100)); then
        echo "Checked 100 IPs"
    fi
    IP="$BASE_RANGE.$i"
    # echo "$IP"
    while [[ $PCNT -ge $NUM_PROCS ]]; do
        sleep 3
        PCNT=$(pcnt)
    done
    if ((NUM_PROCS == 1)); then
        ping_ip "$IP"
    else
        ping_ip "$IP" &
    fi
done
wait
