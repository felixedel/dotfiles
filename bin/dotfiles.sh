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
        clean           Clean package managers (brew)
        pipx            Create pipx environment with python tools
        macos           Apply macOS system defaults
        update [--osx]  Update package and package managers (brew, pipx, uv)
                        Use the --osx flag to also update macOS.

    "
}

sub_clean() {
    brew cleanup
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

    # Updating uv
    echo "Updating uv..."
    uv self update
}

sub_macos() {
    defaults_file="${__dotfiles_dir}/.osxdefaults"
    echo "Applying ${defaults_file}" && source "${defaults_file}"
}

sub_pipx() {
    # Install tools with pipx in isolated environments. The pipx
    # executable is installed via brew.
    pipx install black
    pipx install nox
    pipx install reno
    pipx install tox
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
