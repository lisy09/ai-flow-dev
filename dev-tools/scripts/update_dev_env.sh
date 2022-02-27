#!/usr/bin/env bash

readonly SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
readonly ROOT_DIR="$( cd $SCRIPT_DIR/../.. >/dev/null 2>&1 && pwd )"
readonly WORKSPACE_DIR="$( cd $ROOT_DIR/.. >/dev/null 2>&1 && pwd )"
source $ROOT_DIR/.env

set -eo pipefail

readonly VENV_ABS_PATH=$WORKSPACE_DIR/$VENV_PATH

check_dependencies() {
    echo "Checking dependencies..."
    declare -a deps miss
    deps+=("python")
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

enable_python_venv() {
    echo "Checking python virtualenv in the path: ${VENV_ABS_PATH} ..."
    if [[ ! -d "${VENV_ABS_PATH}" ]]; then
        echo "Error: expected python virtualenv [${VENV_ABS_PATH}] does not exist!"
        exit 1
    fi
    # enable virtualenv
    source ${VENV_ABS_PATH}/bin/activate
    echo "Enabled python venv: [${VENV_ABS_PATH}]"
}
disable_python_venv() {
    echo "Disabled python venv: [${VENV_ABS_PATH}]"
    # disable virtualenv
    deactivate destructive
}

update_python_dev_pkgs() {
    echo "Installing dev python packages in virtualenv..."
    pip install -r $ROOT_DIR/requirements-dev.txt
    echo "Installing dev python packages in virtualenv... Done!"
}

enable_python_venv
update_python_dev_pkgs
disable_python_venv

# cd $WORKSPACE_DIR/ai-flow && make update-dev-env