#!/usr/bin/env bash
#
# daily.sh - creates the daily container in distrobox

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

CONTAINER_NAME=${1:-daily}
CONTAINER_HOME="${2:-$HOME/.box/$CONTAINER_NAME}"
CONTAINER_HOSTNAME="$(hostname).toolbox"
IMAGE='registry.fedoraproject.org/fedora-toolbox'
IMAGE_VERSION=38
ENV=( 'PROMPT_COLOR=5' 'WEZTERM_PREFIX=' )

if [[ -n "$container" ]]; then
    echo "Running distrobox inside a container is not recommended"
    exit 1
fi

POSITIONAL_ARGS=()

while [ $# -gt 0 ]; do
    case $1 in
        -s|--separate-home)
            SEPARATE_HOME=1
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

# bash magic to properly format env vars
ENV=( "${ENV[@]/#/\'-e }" )
ENV=( "${ENV[@]/%/\'}" )

ARGS=()
if [[ -n "$SEPARATE_HOME" ]]; then
    ARGS+=( --home "$CONTAINER_HOME" )
fi

# shellcheck disable=SC2145
# this does not run the setup script, that has to be done manually
distrobox create --image "$IMAGE:$IMAGE_VERSION" \
                 --name "$CONTAINER_NAME" \
                 "${ARGS[@]}" \
                 --additional-flags "${ENV[*]}" \
                 --pre-init-hooks "hostname \"$CONTAINER_HOSTNAME\""

if [[ -n "$RUN_CONFIG" ]]; then
    echo "Running config script, this will take a way"
    echo

    distrobox enter --name "$CONTAINER_NAME" -- ./configs/fedora-toolbox.sh
fi

