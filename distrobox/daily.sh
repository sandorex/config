#!/usr/bin/env bash
#
# daily.sh - creates the daily container in distrobox

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

POSITIONAL_ARGS=()

while [ $# -gt 0 ]; do
    case $1 in
        -s|--share-home)
            SHARE_HOME=1
            shift
            ;;
        --run-config)
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

CONTAINER_NAME=${1:-daily}
CONTAINER_HOME="${2:-$HOME/.box/$CONTAINER_NAME}"
CONTAINER_HOSTNAME="$(hostname)-box"
IMAGE='registry.fedoraproject.org/fedora-toolbox'
IMAGE_VERSION=38

if [[ -n "$container" ]]; then
    echo "Running distrobox inside a container is not recommended"
    exit 1
fi

ARGS=()
if [[ -z "$SHARE_HOME" ]]; then
    ARGS+=( --home "$CONTAINER_HOME" )
fi

# shellcheck disable=SC2145
distrobox create --image "$IMAGE:$IMAGE_VERSION" \
                 --name "$CONTAINER_NAME" \
                 "${ARGS[@]}" \
                 --pre-init-hooks "hostname \"$CONTAINER_HOSTNAME\""

if [[ -n "$RUN_CONFIG" ]]; then
    echo "Running config script, this will take a while.."
    echo

    distrobox enter --name "$CONTAINER_NAME" -- ./configs/fedora-toolbox.sh
fi

