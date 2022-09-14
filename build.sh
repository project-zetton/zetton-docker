#!/usr/bin/env bash

set -euo pipefail

#
# This script requires buildkit: https://docs.docker.com/buildx/working-with-buildx/
#

IMAGE_NAME="projectzetton/zetton-docker"
PACKAGE_NAME=""
PACKAGE_VERSION=""
OS=""
OS_VERSION=""
OS_PATH_NAME=""
ARCHES=""
PULL_ARG=""
LOAD_ARG=""
PUSH_ARG=""
BASE_PATH=""
IMAGE_PREFIX=""
IMAGE_SUFFIX=""
NUM_THREADS="1"
EXTRA_ARGS=""

args=("$@")
script_name=$(basename $0)
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
run_cmd_output=""
run_cmd_return=0
debug_flag=0
dry_run=0

err() {
    local mesg=$1
    shift
    printf "ERROR: $(basename ${BASH_SOURCE[${SOURCE_LINE_OVERRIDE:-1}]})#${BASH_LINENO[${BASH_LINE_OVERRIDE:-0}]} ${mesg}\n\n" "$mesg" 1>&2
    if [[ $# -gt 0 ]]; then
        printf '%s ' "${@}" 1>&2
        printf '\n\n'
    fi
    exit 1
}

msg() {
    local mesg=$1
    shift
    printf ">>> $(basename ${BASH_SOURCE[1]})#${BASH_LINENO[0]} %s\n\n" "$mesg"
    if [[ $# -gt 0 ]]; then
        printf '%s ' "${@}"
        printf '\n\n'
    fi
}

debug() {
    # $1: The message to print.
    if [[ ${debug_flag} -eq 1 ]]; then
        local mesg=$1
        shift
        printf "%s\n\n" "### DEBUG: $(basename ${BASH_SOURCE[${SOURCE_LINE_OVERRIDE:-1}]})#${BASH_LINENO[${BASH_LINE_OVERRIDE:-0}]} ${mesg}" 1>&2
        if [[ $# -gt 0 ]]; then
            printf '%s ' "${@}" 1>&2
            printf '\n\n'
        fi
    fi
}

warning() {
    local mesg=$1
    shift
    printf "WARNING: $(basename ${BASH_SOURCE[${SOURCE_LINE_OVERRIDE:-1}]})#${BASH_LINENO[${BASH_LINE_OVERRIDE:-0}]} ${mesg}\n\n" "$mesg" 1>&2
    if [[ $# -gt 0 ]]; then
        printf '%s ' "${@}" 1>&2
        printf '\n\n'
    fi
}

norun() {
    local mesg=$1
    shift
    printf "XXXX NORUN: $(basename ${BASH_SOURCE[${SOURCE_LINE_OVERRIDE:-1}]})#${BASH_LINENO[${BASH_LINE_OVERRIDE:-0}]} ${mesg}\n\n" "$mesg"
    if [[ $# -gt 0 ]]; then
        printf '%s ' "$@"
        printf '\n\n'
    fi
}

usage() {
    echo "${script_name} - Cuda Image Build Helper"
    echo
    echo "Usage: ${script_name} [options]"
    echo
    echo "OPTIONS"
    echo
    echo "    -h, --help            - Show this message."
    echo "    -n, --dry-run         - Show commands but don't do anything."
    echo "    -d, --debug           - Show debug output."
    echo "    --pull                - Always attempt to pull all referenced images."
    echo "    --load                - Load the images on the build host. (Out of the docker cache)."
    echo "    --push                - Push the images to the remote repository."
    echo "    --image-name=str      - The image name to use. Default: nvcr.io/nvidia/cuda"
    echo "    --package-name=str    - The package name of image to build for."
    echo "    --package-version=str - The package version of image to build for."
    echo "    --os=str              - The target operating system."
    echo "    --os-version=str      - The version of target operating system."
    echo "    --arch=csv            - Target architectures as a comma separated string."
    echo "    --num-threads=int     - Number of threads to build dependencies."
    echo "    --image-suffix=str    - Suffix for built docker image tag."
    echo "    --extra-args=str      - Extra args for building docker image."
    echo
    exit 155
}

# Runs a command. Output is not captured
# To use this function, define the following in your calling script:
# run_cmd_return=""
run_cmd() {
    run_cmd_return=0
    run_cmd_return=0
    # $@: The command and args to run
    if [[ ${dry_run} -eq 1 ]]; then
        SOURCE_LINE_OVERRIDE=2 BASH_LINE_OVERRIDE=1 norun "CMD:" "$@"
    else
        printf "%s\n\n" "$(basename ${BASH_SOURCE[${SOURCE_LINE_OVERRIDE:-1}]})#${BASH_LINENO[${BASH_LINE_OVERRIDE:-0}]} Running command:"
        printf "%s " "${@}"
        printf "\n\n"
        printf "Output: \n\n"
        echo -e "$@" | source /dev/stdin
        run_cmd_return=$?
        echo
        printf "Command returned: %s\n\n" "${run_cmd_return}"
        return $run_cmd_return
    fi
}

if [[ ${#args[@]} -eq 0 ]]; then
    echo
    err "No arguments specified!"
    usage
fi

check_vars() {
    if [[ -z ${PACKAGE_NAME} ]]; then
        err "PACKAGE_NAME argument not set!"
    elif [[ -z ${ARCHES} ]]; then
        err "ARCHES argument not set!"
    elif [[ -z ${OS} ]]; then
        err "OS argument not set!"
    elif [[ -z ${OS_VERSION} ]]; then
        err "OS_VERSION argument not set!"
    fi
    OS_PATH_NAME="${OS}${OS_VERSION}"
    if [[ "${OS_VERSION}" =~ .*\..* ]]; then
        # delete the dot in os string
        msg "Setting OS_PATH_NAME to '${OS}${OS_VERSION//./}'"
        OS_PATH_NAME="${OS}${OS_VERSION//./}"
        debug "OS_PATH_NAME: ${OS_PATH_NAME}"
    fi
    PLATFORM_ARG=$(
        printf '%s ' '--platform'
        for var in $(echo $ARCHES | sed "s/,/ /g"); do printf 'linux/%s,' "$var"; done | sed 's/,*$//g'
    )
    if [[ "${PLATFORM_ARG}" =~ .*,.* ]]; then
        warning "Multiple platforms detected, removing '--load' argument from docker build... (https://github.com/docker/buildx/issues/59)"
        warning "Try doing one platform at a time as a workaround..."
        LOAD_ARG=""
    fi
    BASE_PATH="dist/${PACKAGE_NAME}"
    if [[ ! -z ${PACKAGE_VERSION} ]]; then
        IMAGE_PREFIX="${PACKAGE_NAME}-${PACKAGE_VERSION}"
    else
        IMAGE_PREFIX="${PACKAGE_NAME}"
    fi
}

main() {
    printf "\n"
    msg "${script_name} START"

    for ((a = 0; a < ${#args[@]}; a++)); do
        if [[ ${args[$a]} == "-h" ]] || [[ ${args[$a]} == "--help" ]]; then
            usage
        elif [[ ${args[$a]} == "-n" ]] || [[ ${args[$a]} == "--dry-run" ]]; then
            debug "found arg 'dry-run'"
            dry_run=1
        elif [[ ${args[$a]} == "-d" ]] || [[ ${args[$a]} == "--debug" ]]; then
            debug "found arg 'debug'"
            debug_flag=1
        elif [[ ${args[$a]} == "--pull" ]]; then
            debug "found command '${args[$a]}'"
            PULL_ARG=${args[$a]}
        elif [[ ${args[$a]} == "--load" ]]; then
            debug "found command '${args[$a]}'"
            LOAD_ARG=${args[$a]}
        elif [[ ${args[$a]} == "--push" ]]; then
            debug "found command '${args[$a]}'"
            PUSH_ARG=${args[$a]}
        elif [[ ${args[$a]} == "--image-name" ]]; then
            debug "found command '${args[$a]}'"
            IMAGE_NAME=${args[(($a + 1))]}
            debug "IMAGE_NAME=${IMAGE_NAME}"
            ((a = a + 1))
        elif [[ ${args[$a]} == "--package-name" ]]; then
            debug "found command '${args[$a]}'"
            PACKAGE_NAME=${args[(($a + 1))]}
            debug "PACKAGE_NAME=${IMAGE_NAME}"
            ((a = a + 1))
        elif [[ ${args[$a]} == "--package-version" ]]; then
            debug "found command '${args[$a]}'"
            PACKAGE_VERSION=${args[(($a + 1))]}
            debug "PACKAGE_VERSION=${PACKAGE_VERSION}"
            ((a = a + 1))
        elif [[ ${args[$a]} == "--os" ]]; then
            debug "found command '${args[$a]}'"
            OS=${args[(($a + 1))]}
            debug "OS=${OS}"
            ((a = a + 1))
        elif [[ ${args[$a]} == "--os-version" ]]; then
            debug "found command '${args[$a]}'"
            OS_VERSION=${args[(($a + 1))]}
            debug "OS_VERSION=${OS_VERSION}"
            ((a = a + 1))
        elif [[ ${args[$a]} == "--arch" ]]; then
            debug "found command '${args[$a]}'"
            ARCHES=${args[(($a + 1))]}
            debug "ARCHES=${ARCHES}"
            ((a = a + 1))
        elif [[ ${args[$a]} == "--num-threads" ]]; then
            debug "found command '${args[$a]}'"
            NUM_THREADS=${args[(($a + 1))]}
            debug "NUM_THREADS=${NUM_THREADS}"
            ((a = a + 1))
        elif [[ ${args[$a]} == "--image-suffix" ]]; then
            debug "found command '${args[$a]}'"
            IMAGE_SUFFIX=${args[(($a + 1))]}
            debug "IMAGE_SUFFIX=${IMAGE_SUFFIX}"
            ((a = a + 1))
        elif [[ ${args[$a]} == "--extra-args" ]]; then
            debug "found command '${args[$a]}'"
            EXTRA_ARGS=${args[(($a + 1))]}
            debug "EXTRA_ARGS=${EXTRA_ARGS}"
            ((a = a + 1))
        else
            err "Unknown argument '${args[$a]}'!"
            usage
        fi
    done

    check_vars

    # ubuntu 22.04 build require moby/buildkit version greater than 0.8.1
    if ! docker buildx inspect zetton; then
        run_cmd docker buildx create \
            --use \
            --platform linux/x86_64,linux/arm64 \
            --driver-opt image=moby/buildkit:v0.10.3 \
            --name zetton \
            --node zetton
    fi

    # build base image
    [ -f "${BASE_PATH}/${OS_PATH_NAME}/base/Dockerfile" ] &&
        run_cmd docker buildx build ${PULL_ARG} ${LOAD_ARG} ${PUSH_ARG} ${PLATFORM_ARG} \
            -t "${IMAGE_NAME}:${IMAGE_PREFIX}-base-${OS}${OS_VERSION}${IMAGE_SUFFIX:+-${IMAGE_SUFFIX}}" \
            -f "${BASE_PATH}/${OS_PATH_NAME}/base/Dockerfile" \
            --build-arg "IMAGE_NAME=${IMAGE_NAME}" \
            --build-arg "PACKAGE_VERSION=${PACKAGE_VERSION}" \
            --build-arg "NUM_THREADS=8" \
            ${EXTRA_ARGS} \
            .

    # build runtime image
    [ -f "${BASE_PATH}/${OS_PATH_NAME}/runtime/Dockerfile" ] &&
        run_cmd docker buildx build ${PULL_ARG} ${LOAD_ARG} ${PUSH_ARG} ${PLATFORM_ARG} \
            -t "${IMAGE_NAME}:${IMAGE_PREFIX}-runtime-${OS}${OS_VERSION}${IMAGE_SUFFIX:+-${IMAGE_SUFFIX}}" \
            -f "${BASE_PATH}/${OS_PATH_NAME}/runtime/Dockerfile" \
            --build-arg "IMAGE_NAME=${IMAGE_NAME}" \
            --build-arg "PACKAGE_VERSION=${PACKAGE_VERSION}" \
            --build-arg "NUM_THREADS=8" \
            ${EXTRA_ARGS} \
            .

    # build devel image
    [ -f "${BASE_PATH}/${OS_PATH_NAME}/devel/Dockerfile" ] &&
        run_cmd docker buildx build ${PULL_ARG} ${LOAD_ARG} ${PUSH_ARG} ${PLATFORM_ARG} \
            -t "${IMAGE_NAME}:${IMAGE_PREFIX}-devel-${OS}${OS_VERSION}${IMAGE_SUFFIX:+-${IMAGE_SUFFIX}}" \
            -f "${BASE_PATH}/${OS_PATH_NAME}/devel/Dockerfile" \
            --build-arg "IMAGE_NAME=${IMAGE_NAME}" \
            --build-arg "PACKAGE_VERSION=${PACKAGE_VERSION}" \
            --build-arg "NUM_THREADS=8" \
            ${EXTRA_ARGS} \
            .

    msg "${script_name} END"
}

main
