#!/usr/bin/env bash

readonly SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
readonly ROOT_DIR="$( cd $SCRIPT_DIR/../.. >/dev/null 2>&1 && pwd )"
readonly WORKSPACE_DIR="$( cd $ROOT_DIR/.. >/dev/null 2>&1 && pwd )"
source $ROOT_DIR/.env

set -eo pipefail

readonly VENV_ABS_PATH="$( cd $WORKSPACE_DIR/$VENV_PATH >/dev/null 2>&1 && pwd )"
cmd="source ${VENV_ABS_PATH}/bin/activate"
echo "Please activate python virtualenv with command:"
echo $cmd