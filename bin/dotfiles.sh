#! /usr/bin/env bash

set -o nounset
set -o errexit
set -o pipefail

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename "${__file}")"
__dotfiles_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

arg1="${1:-}"

error() { echo "-- [ERROR] ${*}" 1>&2 && false; }
info() { echo "-- [INFO] ${*}" 1>&2; }
warning() { echo "-- [WARNING] ${*}" 1>&2; }

print_help() {
    echo "Usage:

    ./${__base} <command>

    Commands:

        help            This help message
        clean           Clean package managers (port)
        pipx            Create pipx environment with python tools
        macos           Apply macOS system defaults
        update [--osx]  Update package and package managers (brew, npm, pipx)
                        Use the --osx flag to also update macOS.

    "
}

sub_clean() {
    sudo port clean --all installed # TODO -f option?
    sudo port uninstall inactive # TODO -f option?
}

sub_update() {
    # The macOS update takes very long, even if there is nothing to update.
    # Thus, we make it optional
    if [ -n "${1:-}" ]; then
        read -p "The macOS update could take a while. Continue (y/n)? " yn
        case "${yn:0:1}" in
            y|Y)
                softwareupdate -i -a
                ;;
            *)
                echo "Skipping macOS update"
                ;;
        esac
    fi

    # Update Brew
    echo "Updating Brew..."
    # Update formulae list and brew
    brew update
    # Update packages to newest version
    brew upgrade

    # Update all pipx packages
    echo "Updating pipx packages..."
    pipx upgrade-all
}

sub_macos() {
    defaults_file="${__dotfiles_dir}/.osxdefaults"
    echo "Applying ${defaults_file}" && source "${defaults_file}"
}

sub_pipx() {
    # Create pipx venv
    python3 -m venv ~/.virtualenvs/pipx
    ~/.virtualenvs/pipx/bin/pip install pipx

    # Add pipx binary to path
    ln -s ~/.virtualenvs/pipx/bin/pipx ~/bin/ || true

    # Install tools with pipx in isolated environments
    pipx install black
    pipx install icdiff
    pipx install flake8
    pipx install git-review
    pipx install ipython
    pipx install jupyterlab
    pipx install mypy
    pipx install nox
    pipx install pipenv
    pipx install poetry
    pipx install pre-commit
    pipx install reno
    pipx install tox
    pipx install twine
    pipx install uv
}

case ${arg1} in
    "" | "-h" | "--help")
        print_help
        ;;
    *)
        shift
        sub_${arg1} $@
        if [ $? = 127 ]; then
            error "'${arg1}' is not a known command."
            print_help
        fi
        ;;
esac
shift
