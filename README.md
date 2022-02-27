# ai-flow-dev

This repo setups development environment for all related repos.

## Prerequisite

- The environment for build needs to be linux/amd64 or macos/amd64
- The environemnt for build needs [docker engine installed](https://docs.docker.com/engine/install/)
- have [docker-compose](https://docs.docker.com/compose/install/) installed
- The environemnt for build needs GNU `make` > 3.8 installed
- The environemnt for build needs `bash` shell

[optional]
- for unified IDE support without installing any programming language tools in the local environment, need
  - [Visual Studio Code][vscode] to be [installed][install vscode]
  - [Visual Studio Code Extension: Remote - Containers][vscode remote container] to be installed

## Setup Development Environment

```bash
make setup-dev-env
```

This command will check dependencies to install development tools automatically.

Then run the command to print the command to enable python virtualenv:

```bash
make print-venv-cmd
```

Please execute the command above to enable python virtualenv in your shell session.