#!/bin/bash -e

APPIMAGE_BASE_DIR="$HOME/.local/appimage"
LOG_DIR=$HOME/.local/logs
CALLED_NAME=$(basename "${BASH_SOURCE[0]}")
RESOLVED_NAME=$(basename "$(readlink -f "${BASH_SOURCE[0]}")")
LOG_FILE="${LOG_DIR}/${CALLED_NAME}.log"
APPIMAGE_DIR="$APPIMAGE_BASE_DIR/$CALLED_NAME"
IMAGE=$APPIMAGE_DIR/$CALLED_NAME-latest

log() {
    echo "$(date -Iseconds) - $*" | tee -a "$LOG_FILE"
}

err() {
    log "Error: $*" >&2
    exit 1
}

if [[ "$CALLED_NAME" == "$RESOLVED_NAME" ]]; then
    if (($# > 0)); then
        IMAGE=$1
        shift
        LOG_FILE="${LOG_DIR}/$(basename "$IMAGE").log"
    else
        err "Error: must run as a magic symlink or with the path to an appimage as an argument"
    fi
elif [[ ! -d "$APPIMAGE_DIR" ]]; then
    err "Error: $APPIMAGE_DIR does not exist"
elif [[ ! -e "$IMAGE" ]]; then
    LATEST_IMAGE="$(find "$APPIMAGE_DIR" -type f -exec ls -t {} \+ | head -n 1)"
    if [[ -z "$LATEST_IMAGE" ]]; then
        err "Error: no appimages found in $APPIMAGE_DIR"

    fi
    log "Updating $(basename "$IMAGE") to $(basename "$LATEST_IMAGE")"
    ln -sf "$LATEST_IMAGE" "$IMAGE"
fi

if [[ ! -x "$IMAGE" ]] && ! chmod +x "$IMAGE"; then
    err "Error: $IMAGE is not executable"
fi

exec "$IMAGE" "$@" |& tee -a "$LOG_FILE"
