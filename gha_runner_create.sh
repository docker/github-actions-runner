#!/bin/bash
#
# Simple bash wrapper to create sysbox-based github-actions runners. Script can be easily
# extended to accommodate the various config options offered by the GHA runner.
#

set -o errexit
set -o pipefail
set -o nounset

# Function creates a per-repo runner; it can be easily extended to support org-level
# runners by passing a PAT as ACCESS_TOKEN and set RUNNER_SCOPE="org".
function create_sysbox_gha_runner {
    name=$1
    org=$2
    repo=$3
    token=$4

    docker rm -f $name >/dev/null 2>&1 || true

    docker run -d --restart=always \
        --runtime=sysbox-runc \
        -e REPO_URL="https://github.com/${org}/${repo}" \
        -e RUNNER_TOKEN="$token" \
        -e RUNNER_NAME="$name" \
        -e RUNNER_GROUP="" \
        -e LABELS="" \
        --name "$name" rodnymolina588/gha-sysbox-runner:latest
}

function main() {
    if [[ $# -ne 4 ]]; then
        printf "\nerror: Unexpected number of arguments provided\n"
        printf "\nUsage: ./gha_runner_create.sh <runner-name> <org> <repo-name> <runner-token>\n\n"
        exit 2
    fi

    create_sysbox_gha_runner "$1" "$2" "$3" "$4"
}

main "$@"
