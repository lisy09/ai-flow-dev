init-dev-env:
	bash ${SCRIPT_DIR}/init_dev_env.sh

update-dev-env:
	bash ${SCRIPT_DIR}/update_dev_env.sh

setup-dev-env: init-dev-env update-dev-env

print-venv-cmd:
	bash ${SCRIPT_DIR}/print_venv_cmd.sh


update-repo-vscode-setting:
	bash ${SCRIPT_DIR}/update_repo_vscode_setting.sh

setup-workspace-vscode-setting:
	bash ${SCRIPT_DIR}/setup_workspace_vscode_setting.sh