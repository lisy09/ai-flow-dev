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
    deps+=("docker")
    deps+=("asdf")
    deps+=("grep")
    deps+=("git")
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

check_directory() {
    echo "Checking whether this repo is under proper parent directory..."
    readonly EXPECTED_WORKSPACE_DIR="$( cd $ROOT_DIR/../.. >/dev/null 2>&1 && pwd )/${WORKSPACE_DIR_NAME}"
    if [ "$WORKSPACE_DIR" != "$EXPECTED_WORKSPACE_DIR" ]; then
        echo "Invalid parent directory!"
        echo "Expected: ${EXPECTED_WORKSPACE_DIR}"
        echo "Actual: ${WORKSPACE_DIR}"
        exit 1
    fi
    echo "Checking whether this repo is under proper parent directory... Done!"
}
check_directory

check_python() {
    echo "Checking whether asdf python plugin installed..."
    set +e
    result=`asdf plugin-list | grep python`
    set -e
    if [ -z "$result" ]; then
        echo "asdf python plugin not installed. Installing..."
        asdf plugin-add python
        echo "asdf python plugin not installed. Installing... Done!"
    else
        echo "asdf python plugin already installed."
    fi

    echo "Install python=${PYTHON_VERSION} with asdf if not yet..."
    asdf install python ${PYTHON_VERSION}

    echo "Setting asdf local python version in the workspace: ${WORKSPACE_DIR}..."
    cd ${WORKSPACE_DIR} && asdf local python ${PYTHON_VERSION}
    echo "Setting asdf local python version in the workspace: ${WORKSPACE_DIR}... Done!"

    echo "upgrade pip..."
    pip install --upgrade pip

    cmd="pip install virtualenv"
    echo "Installing python virtualenv if not yet with command:\"$cmd\"..."
    $cmd

    # asdf need reshim after install pip & virtualenv
    asdf reshim python

    echo "Checking python virtualenv in the path: ${VENV_ABS_PATH} ..."
    if [[ -d "$VENV_ABS_PATH" ]]; then
        echo "There already is a python virtualenv at ${VENV_ABS_PATH}."
    else
        echo "No existing python virtualenv. Creating at ${VENV_ABS_PATH}..."
        python -m venv ${VENV_ABS_PATH}
        echo "No existing python virtualenv. Creating at ${VENV_ABS_PATH}... Done!"
    fi

    echo "Setup basic python packages in virtualenv..."
    # enable virtualenv
    source ${VENV_ABS_PATH}/bin/activate
    pip install --upgrade wheel pre-commit
    # disable virtualenv
    deactivate destructive
    echo "Setup basic python packages in virtualenv... Done!"
}
check_python

checkout_repos() {
    repo="ai-flow-origin"
    echo "Checking whether repository [$repo] exists..."
    repo_path=$WORKSPACE_DIR/$repo
    if [ -d "${repo_path}" ]; then
        echo "Skip as [$repo] already exists in ${repo_path}."
    else
        echo "[$repo] does not exist and needs cloning."
        repo_url="git@github.com:flink-extended/ai-flow.git"
        cd $WORKSPACE_DIR && git clone $repo_url $repo
        echo "[$repo] is cloned from ${repo_url}"
    fi


    IFS=',' read -a repo_list <<< ${REPO_LIST}
    for repo in ${repo_list[@]}; do
        echo "Checking whether repository [${repo}] exists..."
        repo_path=$WORKSPACE_DIR/$repo
        if [ -d "${repo_path}" ]; then
            echo "Skip as [$repo] already exists in ${repo_path}."
        else
            echo "[$repo] does not exist and needs cloning."
            repo_url="${REPO_BASE}${repo}"
            cd $WORKSPACE_DIR && git clone $repo_url
            echo "[$repo] is cloned to ${repo_url}"
        fi
    done
}
checkout_repos