#!/usr/bin/env bash

readonly SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
readonly ROOT_DIR="$( cd $SCRIPT_DIR/../.. >/dev/null 2>&1 && pwd )"
readonly WORKSPACE_DIR="$( cd $ROOT_DIR/.. >/dev/null 2>&1 && pwd )"
source $ROOT_DIR/.env

set -eo pipefail

check_dependencies() {
    echo "Checking dependencies..."
    declare -a deps miss
    deps+=("make")
    for COMMAND in ${deps[@]}; do
        if ! command -v ${COMMAND} &> /dev/null; then
            miss+=("${COMMAND}")
        fi
    done

    if [ ${#miss[@]} -gt 0 ]; then
        echo "Commands as dependencies could not be found:"
        for COMMAND in "${miss[@]}"; do
            echo "  $COMMAND"
        done
        exit 1
    else
        echo "Checking dependencies... Done!"
    fi
}
check_dependencies

readonly WORKSPACE_VSCODE_SETTING_PATH=$WORKSPACE_DIR/workspace.code-workspace
cp $WORKSPACE_VSCODE_SETTING_PATH $ROOT_DIR/.vscode/workspace.code-workspace
echo "Copied vscode setting!"