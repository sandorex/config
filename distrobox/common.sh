#!/usr/bin/env bash
#
# common.sh - common logic for distrobox container creation
#
# do not run this file, source it from another with all the options set

set -eu

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

POSITIONAL_ARGS=()

while [ $# -gt 0 ]; do
    case $1 in
        --home)
            CUSTOM_HOME="${2:?}"
            shift 2
            ;;
        --configure)
            RUN_CONFIG=1
            shift
            ;;
        -*)
            echo "Unknown option $1"
            exit 1
            ;;
        *)
            # save positional arg
            POSITIONAL_ARGS+=("$1")
            shift
            ;;
    esac
done

# restore positional parameters
set -- "${POSITIONAL_ARGS[@]}"

CONTAINER_NAME=${1:-${CONTAINER_NAME:?}}
IMAGE="${CONTAINER_IMAGE:?}"

if [[ -n "$container" ]]; then
    echo "Running distrobox inside a container is not recommended"
    exit 1
fi

ARGS=()
if [[ -n "$CUSTOM_HOME" ]]; then
    ARGS+=( --home "$CUSTOM_HOME" )
fi

# do not change the hostname, the hostname should be the same as on host inside
# the container anything else does not resolve properly and cause huge
# stuttering spikes and freezes of whole desktop environment
#
# TODO maybe this could be fixed with some editing but i do not know how

distrobox create --image "$IMAGE" \
                 --name "$CONTAINER_NAME" \
                 "${ARGS[@]}" \
                 --pre-init-hooks "hostname \"$(hostname)\""

if [[ -n "$RUN_CONFIG" ]] && [[ -n "$CONTAINER_SETUP_SCRIPT" ]]; then
    echo "Running config script, this will take a while.."
    echo

    distrobox enter --name "$CONTAINER_NAME" -- "./configs/${CONTAINER_SETUP_SCRIPT}"
fi

