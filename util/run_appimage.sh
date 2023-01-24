#!/bin/bash -e

APPIMAGE_DIR="$HOME/.local/appimage"
LOG_DIR=$HOME/.local/logs
CALLED_NAME=$(basename "${BASH_SOURCE[0]}")
RESOLVED_NAME=$(basename "$(readlink -f "${BASH_SOURCE[0]}")")
LOG_FILE="${LOG_DIR}/${CALLED_NAME}.log"
IMAGE=$APPIMAGE_DIR/$CALLED_NAME/$CALLED_NAME-latest

if [[ "$CALLED_NAME" == "$RESOLVED_NAME" ]]; then
    if (($# > 0)); then
        IMAGE=$1
        LOG_FILE="${LOG_DIR}/$(basename "$IMAGE").log"
        if [[ ! -x "$IMAGE" ]]; then
            echo "Error: $IMAGE is not executable"
            exit 1
        fi
    else
        echo "Error: must run as a symlink or with the path to the appimage as an argument"
        exit 1
    fi
fi

exec "$IMAGE" "$@" &>>"$LOG_FILE"
